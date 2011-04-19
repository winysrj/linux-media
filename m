Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:37646 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981Ab1DSUe2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Apr 2011 16:34:28 -0400
Message-ID: <4DADF1CB.4050504@redhat.com>
Date: Tue, 19 Apr 2011 17:34:19 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Antonio Ospite <ospite@studenti.unina.it>
CC: Jean-Francois Moine <moinejf@free.fr>, linux-media@vger.kernel.org
Subject: Re: [GIT PATCHES FOR 2.6.40] gspca for_v2.6.40
References: <20110419202029.7c9dfd14@tele> <20110419215439.247343e7.ospite@studenti.unina.it>
In-Reply-To: <20110419215439.247343e7.ospite@studenti.unina.it>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 19-04-2011 16:54, Antonio Ospite escreveu:
> On Tue, 19 Apr 2011 20:20:29 +0200
> Jean-Francois Moine <moinejf@free.fr> wrote:
> 
>> The following changes since commit
>> d58307d6a1e2441ebaf2d924df4346309ff84c7d:
>>
>>   [media] anysee: add more info about known board configs (2011-04-19 10:35:37 -0300)
>>
>> are available in the git repository at:
>>   git://linuxtv.org/jfrancois/gspca.git for_v2.6.40
>>
>> Antonio Ospite (2):
>>       Add Y10B, a 10 bpp bit-packed greyscale format.
>>       gspca - kinect: New subdriver for Microsoft Kinect
>>
> 
> Ah glad to see that, so there was no major concern on the code, was
> there?

There's just a problem that I noticed:

drivers/media/video/gspca/kinect.c: In function ‘send_cmd.clone.0’:
drivers/media/video/gspca/kinect.c:202: warning: the frame size of 1548 bytes is larger than 1024 bytes

Please, don't do things like:

+ uint8_t obuf[0x400];
+ uint8_t ibuf[0x200];

at the stack. Instead, put it into a per-device struct.

Anyway, I've applied your patches here. Please send us a fix for it
as soon as possible.

Thanks,
Mauro
