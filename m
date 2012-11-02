Return-path: <linux-media-owner@vger.kernel.org>
Received: from 84-245-11-97.dsl.cambrium.nl ([84.245.11.97]:37209 "EHLO
	grubby.stderr.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753358Ab2KBNOW (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 2 Nov 2012 09:14:22 -0400
From: Matthijs Kooijman <matthijs@stdin.nl>
To: linux-media@vger.kernel.org
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
	Stephan Raue <stephan@openelec.tv>,
	Luis Henriques <luis.henriques@canonical.com>
Subject: Updated patches for (potential) NULL pointer crashes in cir drivers
Date: Fri,  2 Nov 2012 14:13:53 +0100
Message-Id: <1351862036-20384-1-git-send-email-matthijs@stdin.nl>
In-Reply-To: <20121015110111.GD17159@login.drsnuggles.stderr.nl>
References: <20121015110111.GD17159@login.drsnuggles.stderr.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

(Please keep me CC'd, I'm not subscribed to the list)

Hi folks,

I've updated my patches to apply against Mauro's staging/for_v3.8
branch. The patches have only been modified to apply against recent
changes in some of the drivers.

Like before, these patches have been really tested only on nuvoton_cir,
the others received compile-testing only.

Gr.

Matthijs

