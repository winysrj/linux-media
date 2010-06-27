Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754369Ab0F0KYI (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 27 Jun 2010 06:24:08 -0400
Message-ID: <4C2726B7.3050306@redhat.com>
Date: Sun, 27 Jun 2010 07:23:51 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 2/8] ir-core: convert em28xx to not use ir-functions.c
References: <20100607192830.21236.69701.stgit@localhost.localdomain> <20100607193223.21236.36477.stgit@localhost.localdomain>
In-Reply-To: <20100607193223.21236.36477.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 07-06-2010 16:32, David Härdeman escreveu:
> Convert drivers/media/video/em28xx/em28xx-input.c to not use ir-functions.c
> 
> Signed-off-by: David Härdeman <david@hardeman.nu>

This patch caused a bad effect: if some key were pressed before loading the driver, it
causes endless repetitions of the last keycode:

[ 2126.019882] em28xx IR (em28xx #0)/ir: ir->get_key result tb=01 rc=01 lr=01 data=1e07
[ 2126.126629] em28xx IR (em28xx #0)/ir: ir->get_key result tb=01 rc=01 lr=01 data=1e07
[ 2126.233253] em28xx IR (em28xx #0)/ir: ir->get_key result tb=01 rc=01 lr=01 data=1e07
[ 2126.339875] em28xx IR (em28xx #0)/ir: ir->get_key result tb=01 rc=01 lr=01 data=1e07
[ 2126.446625] em28xx IR (em28xx #0)/ir: ir->get_key result tb=01 rc=01 lr=01 data=1e07

I'll try to fix it and apply a patch to solve it.

Cheers,
Mauro
