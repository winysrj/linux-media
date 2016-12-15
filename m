Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud3.xs4all.net ([194.109.24.30]:53947 "EHLO
        lb3-smtp-cloud3.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757414AbcLOI7X (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 15 Dec 2016 03:59:23 -0500
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: [GIT PULL FOR v4.10] media/cobalt: use pci_irq_allocate_vectors
Message-ID: <e2cf8655-a50a-8893-ca4a-32b5ca5e479e@xs4all.nl>
Date: Thu, 15 Dec 2016 09:59:19 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

I completely forgot about this patch until Christoph reminded me. This should go
into 4.10 since other work depends on this.

Apologies for the late pull request, but nobody but me uses the cobalt driver
anyway :-)

Regards,

	Hans

The following changes since commit d183e4efcae8d88a2f252e546978658ca6d273cc:

   [media] v4l: tvp5150: Add missing break in set control handler (2016-12-12 07:49:58 -0200)

are available in the git repository at:

   git://linuxtv.org/hverkuil/media_tree.git for-v4.10e

for you to fetch changes up to b2a35da17382c40393d27ba7f6a99f8c48543852:

   media/cobalt: use pci_irq_allocate_vectors (2016-12-15 09:53:39 +0100)

----------------------------------------------------------------
Christoph Hellwig (1):
       media/cobalt: use pci_irq_allocate_vectors

  drivers/media/pci/cobalt/cobalt-driver.c | 8 ++------
  drivers/media/pci/cobalt/cobalt-driver.h | 2 --
  2 files changed, 2 insertions(+), 8 deletions(-)
