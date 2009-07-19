Return-path: <linux-media-owner@vger.kernel.org>
Received: from rtr.ca ([76.10.145.34]:39016 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754740AbZGSSPq (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 19 Jul 2009 14:15:46 -0400
Message-ID: <4A6362D0.1030400@rtr.ca>
Date: Sun, 19 Jul 2009 14:15:44 -0400
From: Mark Lord <lkml@rtr.ca>
MIME-Version: 1.0
To: Jean Delvare <khali@linux-fr.org>
Cc: Andy Walls <awalls@radix.net>, linux-media@vger.kernel.org,
	Jarod Wilson <jarod@redhat.com>, Mike Isely <isely@pobox.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Janne Grunau <j@jannau.net>
Subject: Re: [PATCH 1/3] ir-kbd-i2c: Allow use of ir-kdb-i2c internal get_key
    funcs and set ir_type
References: <1247862585.10066.16.camel@palomino.walls.org>	<1247862937.10066.21.camel@palomino.walls.org>	<20090719144749.689c2b3a@hyperion.delvare>	<4A6316F9.4070109@rtr.ca>	<20090719145513.0502e0c9@hyperion.delvare>	<4A631B41.5090301@rtr.ca>	<4A631CEA.4090802@rtr.ca>	<4A632FED.1000809@rtr.ca> <20090719190833.29451277@hyperion.delvare>
In-Reply-To: <20090719190833.29451277@hyperion.delvare>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean Delvare wrote:
> On Sun, 19 Jul 2009 10:38:37 -0400, Mark Lord wrote:
>> I'm debugging various other b0rked things in 2.6.31 here right now,
>> so I had a closer look at the Hauppauge I/R remote issue.
>>
>> The ir_kbd_i2c driver *does* still find it after all.
>> But the difference is that the output from 'lsinput' has changed
>> and no longer says "Hauppauge".  Which prevents the application from
>> finding the remote control in the same way as before.
> 
> OK, thanks for the investigation.
> 
>> I'll hack the application code here now to use the new output,
>> but I wonder what the the thousands of other users will do when
>> they first try 2.6.31 after release ?
> 
> Where does lsinput get the string from?
..

Here's a test program for you:

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <linux/input.h>

// Invoke with "/dev/input/event4" as argv[1]
//
// On 2.6.30, this gives the real name, eg. "i2c IR (Hauppauge)".
// On 2.6.31, it simply gives "event4" as the "name".

int main(int argc, char *argv[])
{
	char buf[32];
	int fd, rc;

	fd = open(argv[1], O_RDONLY);
	if (fd == -1) {
		perror(argv[1]);
		exit(1);
	}
	rc = ioctl(fd,EVIOCGNAME(sizeof(buf)),buf);
	if (rc >= 0)
		fprintf(stderr,"   name    : \"%.*s\"\n", rc, buf);
	return 0;
}
