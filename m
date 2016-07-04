Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb2-smtp-cloud2.xs4all.net ([194.109.24.25]:37341 "EHLO
	lb2-smtp-cloud2.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932626AbcGDJyl (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 4 Jul 2016 05:54:41 -0400
To: Josh Wu <rainyfeeling@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: atmel-isi: drop soc-camera dependency?
Message-ID: <efd19f57-e83e-63ea-e490-63fd09443340@xs4all.nl>
Date: Mon, 4 Jul 2016 11:54:37 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Josh,

As you probably know, we are slowly deprecating soc-camera. Several old drivers have
been dropped, others are converted or in the process of being converted.

One driver for which there is no plan AFAIK is the atmel-isi driver. It seems a quite
simple driver, so I was wondering if this is something you could do?

Regards,

	Hans
