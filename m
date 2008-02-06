Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m161RnJn009388
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 20:27:49 -0500
Received: from host06.hostingexpert.com (host06.hostingexpert.com
	[216.80.70.60])
	by mx3.redhat.com (8.13.1/8.13.1) with ESMTP id m161RTol011213
	for <video4linux-list@redhat.com>; Tue, 5 Feb 2008 20:27:29 -0500
Message-ID: <47A90CF0.8090207@linuxtv.org>
Date: Tue, 05 Feb 2008 20:27:12 -0500
From: Michael Krufky <mkrufky@linuxtv.org>
MIME-Version: 1.0
To: Brandon Philips <brandon@ifup.org>
References: <20080205012451.GA31004@plankton.ifup.org>	<47A86350.9090205@linuxtv.org>
	<20080205120102.76ccd526@gaivota>
	<20080205231506.GD10319@plankton.ifup.org>
In-Reply-To: <20080205231506.GD10319@plankton.ifup.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com,
	Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>,
	v4lm <v4l-dvb-maintainer@linuxtv.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: NACK NACK!  [PATCH] Add two new fourcc codes for 16bpp formats
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Brandon Philips wrote:
> On 12:01 Tue 05 Feb 2008, Mauro Carvalho Chehab wrote:
>> On Tue, 05 Feb 2008 08:23:28 -0500
>> Michael Krufky <mkrufky@linuxtv.org> wrote:
>>
>>> Brandon Philips wrote:
>>>> - mailimport changes in this commit too!  Why is mailimport running
>>>>   sudo!?! 
>>> I understand that unrelated changes were accidentally merged with a single commit, but why would we want this script to call sudo in the first place?
>>>
>>> I think it's bad practice, for such a script to execute commands as root -- 
>>>
>>> Can you explain, Mauro?
>> The script itself doesn't open any new vulnerabilities. Sudo only works if 
>> configured at /etc/sudoers.
> 
> I don't use the script but I would certainly remove the sudo calls in my
> local version if I started to.  A patch tool really shouldn't need sudo.
> If the perms are wrong the user can write a wrapper script to fix them.
> 
>> 2) the user of the second account types his password (or, otherwise, sudo is
>> configured to not ask for passwords - on very weak environments).
> 
> sudo defaults to a 15 grace period where it doesn't ask for a password
> again.


I agree with Brandon -- I think the use of sudo here is entirely inappropriate, and there are clearly other ways that a user can address file ownership / permissions issues without this.

-Mike

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
