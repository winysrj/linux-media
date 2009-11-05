Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:4262 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbZKEQ1t (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Thu, 5 Nov 2009 11:27:49 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [BUG] radio-gemtek-pci.c: double mutex_lock
Date: Thu, 5 Nov 2009 17:27:29 +0100
Cc: Alexander Strakh <strakh@ispras.ru>,
	Vladimir Shebordaev <vshebordaev@mail.ru>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Linux Kernlel Mailing List <linux-kernel@vger.kernel.org>
References: <200910081852.50816.strakh@ispras.ru> <alpine.LRH.2.00.0910082046370.12171@twin.jikos.cz>
In-Reply-To: <alpine.LRH.2.00.0910082046370.12171@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911051727.29973.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thursday 08 October 2009 20:47:25 Jiri Kosina wrote:
> On Thu, 8 Oct 2009, Alexander Strakh wrote:
> 
> > 	KERNEL_VERSION: 2.6.31
> > 	DESCRIBE:
> > In driver ./drivers/media/radio/radio-gemtek-pci.c 
> > mutex_lock is called first time in line 184, then in line 186 
> > gemtek_pci_setfrequency is called.
> > 
> > 182 static void gemtek_pci_unmute(struct gemtek_pci *card)
> > 183 {
> > 184		mutex_lock(&card->lock);
> > 185		if (card->mute) {
> > 186         	gemtek_pci_setfrequency(card, card->current_frequency);
> > 187			card->mute = false;
> > 188		}
> > 189		mutex_unlock(&card->lock);190 }
> > 
> > In gemtek_pci_setfrequency we call mutex_lock again in line 152
> > 
> > 144 static void gemtek_pci_setfrequency(struct gemtek_pci *card, unsigned long 
> > frequency)
> > 145 {
> > 146         int i;
> > 147         u32 value = frequency / 200 + 856;
> > 148         u16 mask = 0x8000;
> > 149         u8 last_byte;
> > 150         u32 port = card->iobase;
> > 151
> > 152         mutex_lock(&card->lock);
> 
> Good catch. Adding Hans, who added the (incorrect) locking into 
> gemtek_pci_unmute(), to CC.
> 

Thanks, I've committed a fix and will post a pull request later today.

Sorry for the late reply, but I've been abroad for some time.

Regards,

	Hans

-- 
Hans Verkuil - video4linux developer - sponsored by TANDBERG Telecom
