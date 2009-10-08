Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp.ispras.ru ([83.149.198.201]:50125 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758308AbZJHOus (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 8 Oct 2009 10:50:48 -0400
From: Alexander Strakh <strakh@ispras.ru>
To: Vladimir Shebordaev <vshebordaev@mail.ru>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	linux-media@vger.kernel.org,
	Linux Kernlel Mailing List <linux-kernel@vger.kernel.org>
Subject: [BUG] radio-gemtek-pci.c: double mutex_lock
Date: Thu, 8 Oct 2009 18:52:50 +0000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910081852.50816.strakh@ispras.ru>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

	KERNEL_VERSION: 2.6.31
	DESCRIBE:
In driver ./drivers/media/radio/radio-gemtek-pci.c 
mutex_lock is called first time in line 184, then in line 186 
gemtek_pci_setfrequency is called.

182 static void gemtek_pci_unmute(struct gemtek_pci *card)
183 {
184		mutex_lock(&card->lock);
185		if (card->mute) {
186         	gemtek_pci_setfrequency(card, card->current_frequency);
187			card->mute = false;
188		}
189		mutex_unlock(&card->lock);190 }

In gemtek_pci_setfrequency we call mutex_lock again in line 152

144 static void gemtek_pci_setfrequency(struct gemtek_pci *card, unsigned long 
frequency)
145 {
146         int i;
147         u32 value = frequency / 200 + 856;
148         u16 mask = 0x8000;
149         u8 last_byte;
150         u32 port = card->iobase;
151
152         mutex_lock(&card->lock);

Found by : Linux Driver Verification project
