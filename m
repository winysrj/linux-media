Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.alphaone-tech.com ([174.133.83.186]:60487 "EHLO
	tyler.alphaone-tech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757484Ab2DXXJ3 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 24 Apr 2012 19:09:29 -0400
Message-ID: <4F9726A7.4060208@non-elite.com>
Date: Tue, 24 Apr 2012 17:18:15 -0500
From: Bob W <bob.news@non-elite.com>
MIME-Version: 1.0
To: Konstantin Dimitrov <kosio.dimitrov@gmail.com>
CC: =?ISO-8859-1?Q?Christian_Pr=E4hauser?= <cpraehaus@cosy.sbg.ac.at>,
	linux-media@vger.kernel.org, Marek Ochaba <ochaba@maindata.sk>
Subject: Re: DVB-S2 multistream support
References: <4EF67721.9050102@unixsol.org> <4EF6DD91.2030800@iki.fi> <4EF6F84C.3000307@redhat.com> <CAF0Ff2kkFJYLUjVdmV9d9aWTsi-2ZHHEEjLrVSTCUnP+VTyxRg@mail.gmail.com> <4EF7066C.4070806@redhat.com> <loom.20111227T105753-96@post.gmane.org> <CAF0Ff2mf0tYs3UG3M6Cahep+_kMToVaGgPhTqR7zhRG0UXWuig@mail.gmail.com> <85A7A8FC-150C-4463-B09C-85EED6F851A8@cosy.sbg.ac.at> <CAF0Ff2ncv0PJWSOOw=7WeGyqX3kKiQitY52uEOztfC8Bwj6LgQ@mail.gmail.com> <CAB0B130-3B08-41B4-920A-C54058C43AEE@cosy.sbg.ac.at> <CAF0Ff2kF3VCL4PomOo5zBBrZSPmPvGd9qSZ+XwSp7ALJmq3+kw@mail.gmail.com> <78E6697C-BD32-4062-BC2C-A5F7D0CBD79C@cosy.sbg.ac.at> <CAF0Ff2nCz114LEJFRXy+L7Yq-uD4+sJeHOzNSk=28V_qgbta7A@mail.gmail.com> <loom.20120307T170824-19@post.gmane.org> <CAF0Ff2n1wj5LTu935sR6jxYP8ncHHEA=f6urs8+QKcD2Zd04zg@mail.gmail.com> <4F5F6C2D.1080206@non-elite.com> <A7A0A9AB-3D94-4152-B66D-DDBBF7AE5CAC@cosy.sbg.ac.at> <2FB3FA12-CAFE-4558-9935-1AF14D44DFA9@cosy.sbg.ac.at> <CAF0Ff2=nfGA_jWc4tLnun792C1PN0rZHkGhY=uJz8YHCsFnvKA@mail.gmail.com>
In-Reply-To: <CAF0Ff2=nfGA_jWc4tLnun792C1PN0rZHkGhY=uJz8YHCsFnvKA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



Hi all,

  in playing with these patches, I am noticing the bbframes are only
partially being delivered by the hardware.  I am only getting the first
188 bytes of the frame.

I think it is related to the programming of the saa716xx.

In this function:  saa716x_dma_start the params stuct is filled out,
with 188 in the samples and pitch elements..

does anyone know a little more about this saa716x and how to program
it correctly to receive more data to account for the big bbframes?

thanks

Bob




On 3/19/2012 10:19 AM, Konstantin Dimitrov wrote:
> hello Christian,
> 
> first of all thank you for the great work. so, i have few follow-ups about it:
> 
> 1. since your current patch contains patches that are kernel-specific
> changes (i.e. some general changes to the V4L code for the kernel you
> use), changes related to the BBFrame-support and hardware-specific
> changes (i.e. related to the TBS 6925 card, which at the moment is the
> only affordable hardware at least i know that can handle BBFrames) in
> order for more easy use in different kernels as well for the purpose
> of others to review the changes related to the BBFrame-support in V4L
> 'dvb-core' i split your patch to 3 separate patches (they are attached
> to this email):
> 
> - 01-bb-dmx.patch : it's supposed to contains all changes you made to
> the demux part of V4L 'dvb-core' - i didn't make any further changes -
> just collected your original changes in the patch; it should apply
> clean to all recent kernel released in the last several months (i
> believe at least in the last 6 months), because no changes in this
> parts of 'dvb-core' were made recently
> 
> - 02-bb-fe.patch : those are changes for BBFrame-support related to
> the frontend - i separated those changes and i didn't include them in
> '01-bb-dmx.patch', because recently a lot of changes were made to that
> part of V4L. so, this patch will apply clean to
> "tbs-linux-drivers_v120206" and to other V4L trees most probably it
> will require to manually apply the changes to the respective files,
> but since it changes less than 10 lines in only 3 files that's just
> fine for manual patching
> 
> - 03-bb-tbs.patch : those are all changes specific to the TBS 6925
> hardware. additionally to your changes i defined "tsout" module
> parameter to both 'stv090x' and 'saa716x_tbs-dvb' - that's convenient
> to change between TS and BB mode just with reloading the modules with
> rmmod/modprobe
> 
> 2. so i used the above 3 patches with "tbs-linux-drivers_v120206" and
> after i applied them:
> 
> # cd linux-tbs-drivers
> # patch -p1 < ../01-bb-dmx.patch
> # patch -p1 < ../02-bb-fe.patch
> # patch -p1 < ../03-bb-tbs.patch
> 
> the driver builds successfully, but i'm not sure if i didn't miss
> something from your original patch. also, i put file called
> 'tbs6925.conf' in /etc/modprobe.d with lines in it:
> 
> options stv090x tsout=0
> options saa716x_tbs-dvb tsout=0
> 
> for easy enable/disable of the BB mode with just reloading the modules
> in order to make the testing easier.
> 
> 3. so on the test i did every few seconds i get the following errors:
> 
> _dvb_dmx_swfilter_bbframe: invalid use of reserved TS/GS value 1
> 
> _dvb_dmx_swfilter_bbframe: invalid data field length (length 0, left 10)
> 
> and hex-dump of the BBFrame data. is that supposed to happen? please,
> can you confirm if it happens or not in your environment with your
> original patch or i messed-up something when i prepared the 3 patches
> from point 1. so, that request is in relation to my seconds request -
> please, review the 3 patches from point 1 and confirm they are correct
> and i didn't miss anything - if they are correct patch 01 and 02 can
> be used for review of the code.
> 
> many thanks,
> konstantin
> 

