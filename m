Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:13263 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755436AbdKNOLD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 14 Nov 2017 09:11:03 -0500
Date: Tue, 14 Nov 2017 16:10:57 +0200
From: Sakari Ailus <sakari.ailus@linux.intel.com>
To: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Cc: Alan <alan@linux.intel.com>, vincent.hervieux@gmail.com,
        linux-media@vger.kernel.org
Subject: Re: [PATCH 2/3] atomisp: fix vfree of bogus data on unload
Message-ID: <20171114141057.e3twr7ubztzd7t4m@kekkonen.localdomain>
References: <151001137594.77201.4306351721772580664.stgit@alans-desktop>
 <151001140261.77201.8823780763771880199.stgit@alans-desktop>
 <20171113220548.ji4z4e5neehxg4wn@kekkonen.localdomain>
 <20171114001601.4d51d230@alans-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171114001601.4d51d230@alans-desktop>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Nov 14, 2017 at 12:16:01AM +0000, Alan Cox wrote:
> On Tue, 14 Nov 2017 00:05:48 +0200
> Sakari Ailus <sakari.ailus@linux.intel.com> wrote:
> 
> > Hi Alan,
> > 
> > On Mon, Nov 06, 2017 at 11:36:45PM +0000, Alan wrote:
> > > We load the firmware once, set pointers to it and then at some point release
> > > it. We should not be doing a vfree() on the pointers into the firmware.
> > > 
> > > Signed-off-by: Alan Cox <alan@linux.intel.com>
> > > ---
> > >  .../atomisp/pci/atomisp2/css2400/sh_css_firmware.c |    2 --
> > >  1 file changed, 2 deletions(-)
> > > 
> > > diff --git a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
> > > index 8158ea40d069..f181bd8fcee2 100644
> > > --- a/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
> > > +++ b/drivers/staging/media/atomisp/pci/atomisp2/css2400/sh_css_firmware.c
> > > @@ -288,8 +288,6 @@ void sh_css_unload_firmware(void)
> > >  		for (i = 0; i < sh_css_num_binaries; i++) {
> > >  			if (fw_minibuffer[i].name)
> > >  				kfree((void *)fw_minibuffer[i].name);
> > > -			if (fw_minibuffer[i].buffer)
> > > -				vfree((void *)fw_minibuffer[i].buffer);  
> > 
> > You shouldn't end up here if the firmware is just loaded once. If multiple
> > times, then yes.
> 
> You end up there when unloading the module.

Ah, that's for sure indeed. I thought loading would be already a challenge.
:-)

> 
> > The memory appears to have been allocated using kmalloc() in some cases.
> > How about kvfree(), or changing that kmalloc() to vmalloc()
> 
> I'll take a deeper look at what is going on.

Look for minibuffer in sh_css_load_blob_info(). The buffer field of the
struct is allocated using kmalloc, I wonder if changing that to vmalloc
would just address this.

The buffer is elsewhere allocated using vmalloc. I suspect that some of the
cleanup patches changed how this works but missed changing the other one.

-- 
Regards,

Sakari Ailus
sakari.ailus@linux.intel.com
