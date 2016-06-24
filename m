Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:45328
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbcFXULB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 24 Jun 2016 16:11:01 -0400
Date: Fri, 24 Jun 2016 17:10:55 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Luis de Bethencourt <luisbg@osg.samsung.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 11/19] cx25821-alsa: shutup a Gcc 6.1 warning
Message-ID: <20160624171055.7c744bae@recife.lan>
In-Reply-To: <576D7022.5090208@osg.samsung.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
	<114e877a8f89113ffdef8c6a751048c660a6c9f3.1466782238.git.mchehab@s-opensource.com>
	<576D7022.5090208@osg.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 24 Jun 2016 18:38:42 +0100
Luis de Bethencourt <luisbg@osg.samsung.com> escreveu:

> On 24/06/16 16:31, Mauro Carvalho Chehab wrote:
> > The PCI device ID table is only used if compiled with modules
> > support. When compiled with modules disabled, this is now
> > producing this bogus warning:
> > 
> > drivers/media/pci/cx25821/cx25821-alsa.c:696:35: warning: 'cx25821_audio_pci_tbl' defined but not used [-Wunused-const-variable=]
> >  static const struct pci_device_id cx25821_audio_pci_tbl[] = {
> >                                    ^~~~~~~~~~~~~~~~~~~~~
> > 
> > Fix it by annotating that the function may not be used.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> >  drivers/media/pci/cx25821/cx25821-alsa.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/media/pci/cx25821/cx25821-alsa.c b/drivers/media/pci/cx25821/cx25821-alsa.c
> > index b602eba2b601..df189b16af12 100644
> > --- a/drivers/media/pci/cx25821/cx25821-alsa.c
> > +++ b/drivers/media/pci/cx25821/cx25821-alsa.c
> > @@ -693,7 +693,7 @@ static int snd_cx25821_pcm(struct cx25821_audio_dev *chip, int device,
> >   * Only boards with eeprom and byte 1 at eeprom=1 have it
> >   */
> >  
> > -static const struct pci_device_id cx25821_audio_pci_tbl[] = {
> > +static const struct pci_device_id __maybe_unused cx25821_audio_pci_tbl[] = {
> >  	{0x14f1, 0x0920, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
> >  	{0,}
> >  };
> >   
> 
> In which branch is this happening? I can't seem to be able to reproduce it.

It is at the master branch. It appears if compiled with W=1 and
gcc 6.1.

Thanks,
Mauro
