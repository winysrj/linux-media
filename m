Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr8.xs4all.nl ([194.109.24.28]:1808 "EHLO
	smtp-vbr8.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab2HNNxI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 14 Aug 2012 09:53:08 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [ANNOUNCE] tree renaming patches part 1 applied
Date: Tue, 14 Aug 2012 15:53:02 +0200
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
References: <502A3DAF.6080301@redhat.com>
In-Reply-To: <502A3DAF.6080301@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208141553.02247.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue August 14 2012 13:59:43 Mauro Carvalho Chehab wrote:
> Yesterday, I finally applied the first part of the renaming patches:
> 
>  * [RFC,10/10,media] break siano into mmc and usb directories
>      - http://patchwork.linuxtv.org/patch/11755/
> 
>  * [RFC,09/10,media] saa7146: Move it to its own directory
>      - http://patchwork.linuxtv.org/patch/11750/
> 
>  * [RFC,07/10,media] b2c2: break it into common/pci/usb directories
>      - http://patchwork.linuxtv.org/patch/11754/
> 
>  * [RFC,03/10,media] move the dvb/frontends to drivers/media/dvb-frontends
>      - http://patchwork.linuxtv.org/patch/11752/
> 
>  * [RFC,05/10,media] dvb-usb: move it to drivers/media/usb/dvb-usb
>      - http://patchwork.linuxtv.org/patch/11751/
> 
>  * [RFC,06/10,media] Rename media/dvb as media/pci
>      - http://patchwork.linuxtv.org/patch/11753/
> 
>  * [RFC,04/10,media] firewire: move it one level up
>      - http://patchwork.linuxtv.org/patch/11746/
> 
>  * [RFC,02/10,media] dvb: move the dvb core one level up
>      - http://patchwork.linuxtv.org/patch/11747/
> 
>  * [RFC,08/10,media] common: move media/common/tuners to media/tuners
>      - http://patchwork.linuxtv.org/patch/11748/
> 
>  * [RFC,01/10,media] v4l: move v4l2 core into a separate directory
>      - http://patchwork.linuxtv.org/patch/11749/
> 
> As discussed when that patch series got submitted, the target there is to
> better organize the drivers, in order to make easier for developers to
> know where the things are, and for users to help them to find their
> needed drivers.
> 
> I'll be working today with the remaining patches to complete the renaming,
> as it is better to apply them sooner than later, and we're early at the
> development cycle.
> 
> Before applying this patch series, I applied almost all pending patches
> at the tree, in order to reduce the need for patch changes. I also
> reminded on IRC some developers that I was aware that they would be
> having pending work.
> 
> Anyway, in order to help people that might still have patches against
> the old structure, I created a small script and added them at the
> media_build tree:
> 	http://git.linuxtv.org/media_build.git/blob/HEAD:/devel_scripts/rename_patch.sh
> 
> (in fact, I created an script that auto-generated it ;) )
> 
> To use it, all you need to do is:
> 
> 	$ ./rename_patch.sh your_patch
> 
> As usual, if you want to change several patches, you could do:
> 	$ git format_patch some_reference_cs
> 
> and apply the rename_patch.sh to the generated 0*.patch files, like
> 	$ for i in 0*.patch; do ./rename_patch.sh $i; done
> 
> More details about that are at the readme file:
> 	http://git.linuxtv.org/media_build.git/blob/HEAD:/devel_scripts/README

Mauro, thank you for your work on this!

I'm sure that due to these changes the daily build will fail. It did last night,
but due to a bug in the build script it hung and didn't produce an error report,
something that is now hopefully fixed.

I'll wait with updating anything in media_build or elsewhere until the whole
reorganization is finished. Mauro, can you drop me an email when you think
everything is done? Then I can work on getting the daily build back up.

Are you planning to update the backport patches in media_build as well?

Regards,

	Hans
