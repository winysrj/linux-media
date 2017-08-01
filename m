Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33952 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751815AbdHAR5S (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 1 Aug 2017 13:57:18 -0400
From: Arvind Yadav <arvind.yadav.cs@gmail.com>
To: corbet@lwn.net, mchehab@kernel.org, awalls@md.metrocast.net,
        hverkuil@xs4all.nl, serjk@netup.ru, aospan@netup.ru,
        hans.verkuil@cisco.com
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 00/18] constify media pci_device_id
Date: Tue,  1 Aug 2017 23:26:16 +0530
Message-Id: <1501610194-8231-1-git-send-email-arvind.yadav.cs@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

pci_device_id are not supposed to change at runtime. All functions
working with pci_device_id provided by <linux/pci.h> work with
const pci_device_id. So mark the non-const structs as const.

Arvind Yadav (18):
  [PATCH 01/18] [media] marvell-ccic: constify pci_device_id.
  [PATCH 02/18] [media] netup_unidvb: constify pci_device_id.
  [PATCH 03/18] [media] cx23885: constify pci_device_id.
  [PATCH 04/18] [media] meye: constify pci_device_id.
  [PATCH 05/18] [media] pluto2: constify pci_device_id.
  [PATCH 06/18] [media] dm1105: constify pci_device_id.
  [PATCH 07/18] [media] zoran: constify pci_device_id.
  [PATCH 08/18] [media] bt8xx: constify pci_device_id.
  [PATCH 09/18] [media] bt8xx: bttv: constify pci_device_id.
  [PATCH 10/18] [media] ivtv: constify pci_device_id.
  [PATCH 11/18] [media] cobalt: constify pci_device_id.
  [PATCH 12/18] [media] b2c2: constify pci_device_id.
  [PATCH 13/18] [media] saa7164: constify pci_device_id.
  [PATCH 14/18] [media] pt1: constify pci_device_id.
  [PATCH 15/18] [media] mantis: constify pci_device_id.
  [PATCH 16/18] [media] mantis: hopper_cards: constify pci_device_id.
  [PATCH 17/18] [media] cx18: constify pci_device_id.
  [PATCH 18/18] [media] radio: constify pci_device_id.

 drivers/media/pci/b2c2/flexcop-pci.c               | 2 +-
 drivers/media/pci/bt8xx/bt878.c                    | 2 +-
 drivers/media/pci/bt8xx/bttv-driver.c              | 2 +-
 drivers/media/pci/cobalt/cobalt-driver.c           | 2 +-
 drivers/media/pci/cx18/cx18-driver.c               | 2 +-
 drivers/media/pci/cx23885/cx23885-core.c           | 2 +-
 drivers/media/pci/dm1105/dm1105.c                  | 2 +-
 drivers/media/pci/ivtv/ivtv-driver.c               | 2 +-
 drivers/media/pci/mantis/hopper_cards.c            | 2 +-
 drivers/media/pci/mantis/mantis_cards.c            | 2 +-
 drivers/media/pci/meye/meye.c                      | 2 +-
 drivers/media/pci/netup_unidvb/netup_unidvb_core.c | 2 +-
 drivers/media/pci/pluto2/pluto2.c                  | 2 +-
 drivers/media/pci/pt1/pt1.c                        | 2 +-
 drivers/media/pci/saa7164/saa7164-core.c           | 2 +-
 drivers/media/pci/zoran/zoran_card.c               | 2 +-
 drivers/media/platform/marvell-ccic/cafe-driver.c  | 2 +-
 drivers/media/radio/radio-maxiradio.c              | 2 +-
 18 files changed, 18 insertions(+), 18 deletions(-)

-- 
2.7.4
