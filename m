Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:38784
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1756757AbdGLMiK (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 12 Jul 2017 08:38:10 -0400
Date: Wed, 12 Jul 2017 09:37:56 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        xen-devel <xen-devel@lists.xenproject.org>,
        linux-block <linux-block@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        IDE-ML <linux-ide@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alan Cox <alan@llwyncelyn.cymru>
Subject: Re: Lots of new warnings with gcc-7.1.1
Message-ID: <20170712093552.15aebacd@vento.lan>
In-Reply-To: <CA+55aFzXz-PxKSJP=hfHD+mfCX4M6+HMacWMkDz7KB8-3y55qw@mail.gmail.com>
References: <CA+55aFzXz-PxKSJP=hfHD+mfCX4M6+HMacWMkDz7KB8-3y55qw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Tue, 11 Jul 2017 15:35:15 -0700
Linus Torvalds <torvalds@linux-foundation.org> escreveu:

> [ Very random list of maintainers and mailing lists, at least
> partially by number of warnings generated by gcc-7.1.1 that is then
> correlated with the get_maintainers script ]

Under drivers/media, I fixed a bunch of gcc 7.1 warnings before the
merge window. While most were just noise, some actually pointed to
human errors.

Now, gcc-7.1.1 produces only 6 warnings with W=1 on x86_64 (allyesconfig), 
either due to unused-but-set-variable or unused-const-variable. I guess
both warning options are disabled by default. Anyway, I have patches
to fix them already. I'll send you later.

The atomisp staging driver is a completely different beast, with would
produce itself a huge amount of warnings. I ended by adding some
logic on drivers/staging/media/atomisp/ Makefiles to disable them:

	ccflags-y += $(call cc-disable-warning, missing-declarations)
	ccflags-y += $(call cc-disable-warning, missing-prototypes)
	ccflags-y += $(call cc-disable-warning, unused-but-set-variable)
	ccflags-y += $(call cc-disable-warning, unused-const-variable)
	ccflags-y += $(call cc-disable-warning, suggest-attribute=format)
	ccflags-y += $(call cc-disable-warning, implicit-fallthrough)

(there's actually one patch pending related to atomisp, that I'll also
be sending you soon - meant to avoid warnings if compiled with an older
gcc version)

Thanks,
Mauro
