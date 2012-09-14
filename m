Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39962 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab2INOBS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 14 Sep 2012 10:01:18 -0400
Received: by lbbgj3 with SMTP id gj3so2771498lbb.19
        for <linux-media@vger.kernel.org>; Fri, 14 Sep 2012 07:01:17 -0700 (PDT)
Message-ID: <50533862.9030900@mvista.com>
Date: Fri, 14 Sep 2012 18:00:02 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>,
	DLOS <davinci-linux-open-source@linux.davincidsp.com>,
	David Oleszkiewicz <doleszki@adsyscontrols.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] davinci: vpif: capture/display: fix race condition
References: <1347630836-7545-1-git-send-email-prabhakar.lad@ti.com>
In-Reply-To: <1347630836-7545-1-git-send-email-prabhakar.lad@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 09/14/2012 05:53 PM, Prabhakar Lad wrote:

> From: Lad, Prabhakar <prabhakar.lad@ti.com>

> channel_first_int[][] variable is used as a flag for the ISR,
> This flag was being set after enabling the interrupts, There
> where suitaions when the isr ocuurend even before the flag was set

   s/suitaions/situations/, s/ocuurend/occured/

> dues to which it was causing the applicaiotn hang.

   Application.

> This patch sets  channel_first_int[][] flag just before enabling the
> interrupt.

> Reported-by: David Oleszkiewicz <doleszki@adsyscontrols.com>
> Signed-off-by: Lad, Prabhakar <prabhakar.lad@ti.com>
> Signed-off-by: Manjunath Hadli <manjunath.hadli@ti.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>

WBR, Sergei

