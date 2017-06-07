Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:52898
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1750831AbdFGP5z (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Wed, 7 Jun 2017 11:57:55 -0400
Date: Wed, 7 Jun 2017 12:57:47 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: "Jasmin J." <jasmin@anw.at>, rjkm@metzlerbros.de
Cc: linux-media@vger.kernel.org, max.kellermann@gmail.com,
        d.scheller@gmx.net
Subject: Re: [PATCH 0/7] Add block read/write to en50221 CAM functions
Message-ID: <20170607125747.63d057c2@vento.lan>
In-Reply-To: <1494190313-18557-1-git-send-email-jasmin@anw.at>
References: <1494190313-18557-1-git-send-email-jasmin@anw.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun,  7 May 2017 22:51:46 +0200
"Jasmin J." <jasmin@anw.at> escreveu:

> From: Jasmin Jessich <jasmin@anw.at>
> 
> These patch series implement a block read/write interface to the en50221
> CAM control functions. The origin of this patches can be found in the
> Digital Devices Git on https://github.com/DigitalDevices/dddvb maintained
> by Ralph Metzler <rjkm@metzlerbros.de>
> 
> The relevant changes concerning dvb-core/dvb_ca_en50221.c/.h and
> cxd2099/cxd2099.c/.h have been extracted from the mentioned repository by
> Daniel Scheller <d.scheller@gmx.net> and committed to his branch on
> https://github.com/herrnst/dddvb-linux-kernel/tree/mediatree/master-cxd2099
> 
> I split the patch set is smaller pieces for easier review, compiled each
> step, fixed code style issues in cxd2099/cxd2099.c/.h (checkpatch.pl) and
> tested the resulting driver on my hardware with the DD DuoFlex CI (single)
> card.
> 
> Please note, that the block read/write functionality is already implemented
> in the currently existing cxd2099/cxd2099.c/.h driver, but deactivated. The
> existing code in this driver is also not functional and has been updated by
> the working implementation from the Digital Devices Git.
> 
> Additionally to the block read/write functions, I merged also two patches
> in the en50221 CAM control state machine, which were existing in the
> Digital Devices Git. This are the first two patches of this series.
> 
> There is another patch series coming soon "Fix coding style in en50221 CAM
> functions" which fixes nearly all the style issues in
> dvb-core/dvb_ca_en50221.c/.h, based on this patch series. So please be
> patient, if any of the dvb_ca_en50221.c/.h might be not 100% checkpatch.pl
> compliant. I tried to keep the original patch code from DD as much as
> possible.
> 
> Apologizes if anything regarding the patch submission is/went wrong, as
> this is my first time contribution of a patch set.
> 
> 
> Jasmin Jessich (7):
>   [media] dvb-core/dvb_ca_en50221.c: State UNINITIALISED instead of INVALID
>   [media] dvb-core/dvb_ca_en50221.c: Increase timeout for link init
>   [media] dvb-core/dvb_ca_en50221.c: Add block read/write functions
>   [staging] cxd2099/cxd2099.c/.h: Fixed buffer mode
>   [media] ddbridge/ddbridge-core.c: Set maximum cxd2099 block size to 512
>   [staging] cxd2099/cxd2099.c: Removed useless printing in cxd2099 driver
>   [staging] cxd2099/cxd2099.c: Activate cxd2099 buffer mode

Hmm... from what I understood, the original author for those patches
is Ralph, right?

Regards,
Mauro
