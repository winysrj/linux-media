Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184Ab0F1RqC (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 28 Jun 2010 13:46:02 -0400
Message-ID: <4C28DFCA.5070406@redhat.com>
Date: Mon, 28 Jun 2010 14:45:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: =?UTF-8?B?RGF2aWQgSMOkcmRlbWFu?= <david@hardeman.nu>
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 8/8] ir-core: merge rc-map.h into ir-core.h
References: <20100607192830.21236.69701.stgit@localhost.localdomain> <20100607193253.21236.98706.stgit@localhost.localdomain>
In-Reply-To: <20100607193253.21236.98706.stgit@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 07-06-2010 16:32, David Härdeman escreveu:
> Haven't discussed this patch on the linux-media list yet, but
> merging rc-map.h into ir-core.h at least makes it much easier
> for me to get a good overview of the entire rc-core subsystem
> (and to make sweeping changes). Not sure if everyone agrees?

I don't like the idea of merging those headers. It will just slow
down the build time when a change at the core is applied, as all
rc tables would need to be rebuilt for no good reason.

Cheers,
Mauro
