Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m514l43b022554
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 00:47:04 -0400
Received: from mail-in-12.arcor-online.net (mail-in-12.arcor-online.net
	[151.189.21.52])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m514jnNt005006
	for <video4linux-list@redhat.com>; Sun, 1 Jun 2008 00:45:59 -0400
From: hermann pitton <hermann-pitton@arcor.de>
To: Carl Karsten <carl@personnelware.com>
In-Reply-To: <4840F22C.2060908@personnelware.com>
References: <47C8A0C9.4020107@personnelware.com>
	<20080304112519.6f4c748c@gaivota>	<483DBD67.8090508@personnelware.com>
	<20080528173755.594ea08b@gaivota> <483DD6AA.1070203@personnelware.com>
	<1212015588.5745.9.camel@pc10.localdom.local>
	<483DEB53.40604@personnelware.com>
	<1212021382.5745.13.camel@pc10.localdom.local>
	<4840F22C.2060908@personnelware.com>
Content-Type: text/plain
Date: Sun, 01 Jun 2008 06:38:23 +0200
Message-Id: <1212295103.8234.25.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: [patch] vivi: registered as /dev/video%d
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


Am Samstag, den 31.05.2008, 01:37 -0500 schrieb Carl Karsten:
> hermann pitton wrote:
> > Am Mittwoch, den 28.05.2008, 18:31 -0500 schrieb Carl Karsten:
> >> hermann pitton wrote:
> >>> Hi Carl,
> >>>
> >>> Am Mittwoch, den 28.05.2008, 17:03 -0500 schrieb Carl Karsten:
> >>>> Mauro Carvalho Chehab wrote:
> >>>>> On Wed, 28 May 2008 15:15:35 -0500
> >>>>> Carl Karsten <carl@personnelware.com> wrote:
> >>>>>
> >>>>>> I posted a week ago and haven't heard anything.
> >>>>> I was on vacations last week.
> >>>>>
> >>>>>>  How long should I wait before 
> >>>>>> posting this? :)
> >>>>> There are a few issues on your patch:
> >>>>>
> >>>>>> -		else
> >>>>>> +            printk(KERN_INFO "%s: /dev/video%d unregistered.\n", MODULE_NAME,
> >>>>>> dev->vfd->minor);
> >>>>> Your patch got word wrapped. So, it didn't apply.
> >>>>>
> >>>>>> +        }
> >>>>>> +		else {
> >>>>> CodingStyle is wrong. It should be:
> >>>>> 	} else {
> >>>>>
> >>>>> (at the same line)
> >>>>>
> >>>>> Also, on some places, you used space, instead of tabs.
> >>>>>
> >>>>> Please, check your patch with checkpatch.pl (or, inside Mercurial, make
> >>>>> checkpatch) before sending it.
> >>>>>
> >>>>> Also, be sure that your emailer won't add line breaks at the wrong places.
> >>>>>>   	} else
> >>>>>>   		printk(KERN_INFO "Video Technology Magazine Virtual Video "
> >>>>>> -				 "Capture Board successfully loaded.\n");
> >>>>>> +                 "Capture Board ver %u.%u.%u successfully loaded.\n",
> >>>>>> +        (VIVI_VERSION >> 16) & 0xFF, (VIVI_VERSION >> 8) & 0xFF, VIVI_VERSION &
> >>>>>> 0xFF);
> >>>> Fixed what you mentioned, make checkpatch doesn't report anything now.  It was 
> >>>> reporting "warning: line over 80 characters" so now that those are fixed maybe 
> >>>> t-bird won't wrap them.
> >>> your hope is in vain for the one space indent in front of every line
> >>> tbird adds. We have that issue already seen with your previous patches
> >>> and I told you about, it is a very well known tbird flaw ;)
> >>>
> >>> Please use always attachments with thunderbird.
> >>> It is no fun to fix all lines for indentation.
> >> Sorry about that - I meant to attach it too.
> >>
> >> What is the proper way to supply:
> >>
> >> Signed-off-by: Carl Karsten  <carl@personnelware.com>
> >>
> >> Carl K
> 
> list ate .diff, trying .patch.
> 
> Carl K
> 

Hi Carl,

patch is there now and others seem to come through with .diff stuff.

Always send to Mauro directly or at least maintainers list too.

Under the current load Mauro has, the video4linux list only is no safe
place for patches anymore.

Cheers,
Hermann




--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
