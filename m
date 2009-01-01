Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id n01Ftold004306
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 10:55:50 -0500
Received: from mail-in-09.arcor-online.net (mail-in-09.arcor-online.net
	[151.189.21.49])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id n01FtXqf031844
	for <video4linux-list@redhat.com>; Thu, 1 Jan 2009 10:55:33 -0500
From: hermann pitton <hermann-pitton@arcor.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
In-Reply-To: <Pine.LNX.4.64.0812171914550.8733@axis700.grange>
References: <Pine.LNX.4.64.0812171914550.8733@axis700.grange>
Content-Type: text/plain
Date: Thu, 01 Jan 2009 16:56:13 +0100
Message-Id: <1230825373.2669.9.camel@pc10.localdom.local>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: "patches can be modified..."
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

Hi,

Am Donnerstag, den 01.01.2009, 12:52 +0100 schrieb Guennadi
Liakhovetski:
> Hi all,
> 
> everyone who has once got his or her patch committed to v4l received an 
> auto-reply
> 
> From: Patch added by Xxxxx Xxxxx <hg-commit@linuxtv.org>
> To: linuxtv-commits@linuxtv.org
> 
> with a comment:
> 
> <quote>
> The patch number NNNN was added via name <user@provider.com>
> to http://linuxtv.org/hg/v4l-dvb master development tree.
> 
> Kernel patches in this development tree may be modified to be backward
> compatible with older kernels. Compatibility modifications will be
> removed before inclusion into the mainstream Kernel
> 
> If anyone has any objections, please let us know by sending a message to:
> 	v4l-dvb-maintainer@linuxtv.org
> </quote>
> 
> What does this mean? Does the last sentence refer to "patches may be 
> modified" or to "patch was added"? And why should objections against 
> either of them be sent to the maintainer instead of being discussed on the 
> list? Don't understand. Does it mean that if a specific author has 
> objections, the respective driver can be left off from the 
> backwards-compatibility conversions?
> 
> Thanks
> Guennadi

it means any backward compat is stripped if forwarded to Linus.

It is not about to discuss backward compatibility we keep internally in
mercurial v4l-dvb.

Objections should be against the patch as it goes to mainline.

Cheers,
Hermann


--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
