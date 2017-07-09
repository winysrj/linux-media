Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:52806 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752512AbdGITw4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 9 Jul 2017 15:52:56 -0400
Date: Sun, 9 Jul 2017 22:52:51 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: hari prasath <gehariprasath@gmail.com>
Cc: mchehab@kernel.org,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, rvarsha016@gmail.com,
        Julia Lawall <julia.lawall@lip6.fr>,
        SIMRAN SINGHAL <singhalsimran0@gmail.com>,
        linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: atomisp: use kstrdup to replace kmalloc and
 memcpy
Message-ID: <20170709195250.hu3psedjrvjkhivv@valkosipuli.retiisi.org.uk>
References: <20170707144521.4520-1-gehariprasath@gmail.com>
 <20170708110157.jkpg6foz35lckdqu@ihha.localdomain>
 <CAHHWPbfxGxJ6_N=rx1ZFW-DnTTAui0qYcbCjrY=ke3mGJF_kkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHHWPbfxGxJ6_N=rx1ZFW-DnTTAui0qYcbCjrY=ke3mGJF_kkA@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, Jul 09, 2017 at 05:56:15PM +0530, hari prasath wrote:
> On 8 July 2017 at 16:31, Sakari Ailus <sakari.ailus@iki.fi> wrote:
> > Hi Hari,
> >
> > On Fri, Jul 07, 2017 at 08:15:21PM +0530, Hari Prasath wrote:
> >> kstrdup kernel primitive can be used to replace kmalloc followed by
> >> string copy. This was reported by coccinelle tool
> >>
> >> Signed-off-by: Hari Prasath <gehariprasath@gmail.com>
> >> ---
> >>  .../media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c       | 10 +++-------
> >>  1 file changed, 3 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
> >> index 34cc56f..68db87b 100644
> >> --- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
> >> +++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
> >> @@ -144,14 +144,10 @@ sh_css_load_blob_info(const char *fw, const struct ia_css_fw_info *bi, struct ia
> >>       )
> >>       {
> >>               char *namebuffer;
> >> -             int namelength = (int)strlen(name);
> >> -
> >> -             namebuffer = (char *) kmalloc(namelength + 1, GFP_KERNEL);
> >> -             if (namebuffer == NULL)
> >> -                     return IA_CSS_ERR_CANNOT_ALLOCATE_MEMORY;
> >> -
> >> -             memcpy(namebuffer, name, namelength + 1);
> >>
> >> +             namebuffer = kstrdup(name, GFP_KERNEL);
> >> +             if (!namebuffer)
> >> +                     return -ENOMEM;
> >
> > The patch also changes the return value in error cases. I believe the
> > caller(s) expect to get errors in the IA_CCS_ERR_* range.
> 
> Hi,
> 
> In this particular case, the calling function just checks if it's not
> success defined by a enum. I think returning -ENOMEM would not effect,
> at least in this case.

It might not, but the function now returns both negative Posix and positive
CSS error codes. The CSS error codes could well be converted to Posix but
it should be done consistently and preferrably in a separate patch.

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
