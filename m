Return-path: <linux-media-owner@vger.kernel.org>
Received: from node6.gecad.com ([193.230.245.6]:40768 "EHLO node6.gecad.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbZHaLC4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2009 07:02:56 -0400
Subject: Re: [linux-dvb] saa 7162 chip, recording from s-video
From: Eduard Budulea <eduard.budulea@axigen.com>
To: DCRYPT@telefonica.net
Cc: linux-media@vger.kernel.org
In-Reply-To: <18203149.1251714450755.JavaMail.root@ctps3>
References: <18203149.1251714450755.JavaMail.root@ctps3>
Content-Type: text/plain
Date: Mon, 31 Aug 2009 14:00:18 +0300
Message-Id: <1251716418.3990.25.camel@edi-desktop>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 2009-08-31 at 12:27 +0200, DCRYPT@telefonica.net wrote:
> Eduard,
> 
> Could you please specify what to do in order to add a PCI ID to the 
> driver list? I was investigating by myself some time ago, but could not 
> manage to do it.
> 
you go to saa716x_hybrid.c
and add a "MAKE_ENTRY" to
static struct pci_device_id saa716x_hybrid_pci_table
structure. (know it is at line 592)
You have to choose a config structure for your card I have choose
saa716x_atlantis_config and I think it worked.

