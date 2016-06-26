Return-path: <linux-media-owner@vger.kernel.org>
Received: from mout02.posteo.de ([185.67.36.66]:47418 "EHLO mout02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbcFZVhz (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 26 Jun 2016 17:37:55 -0400
Received: from submission (posteo.de [89.146.220.130])
	by mout02.posteo.de (Postfix) with ESMTPS id 64EA420AA5
	for <linux-media@vger.kernel.org>; Sun, 26 Jun 2016 23:30:32 +0200 (CEST)
Date: Sun, 26 Jun 2016 23:30:27 +0200
From: Patrick Boettcher <patrick.boettcher@posteo.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [PATCH 13/19] dib0090: comment out the unused tables
Message-ID: <20160626233027.06413f2d@vdr>
In-Reply-To: <cf47faca25e29ffb74c883675a9bada065d9ea10.1466782238.git.mchehab@s-opensource.com>
References: <cover.1466782238.git.mchehab@s-opensource.com>
	<cf47faca25e29ffb74c883675a9bada065d9ea10.1466782238.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On Fri, 24 Jun 2016 12:31:54 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:

> Those tables are currently unused, so comment them out:

We actually could remove these tables. It is very, very unlikely that
this device will ever be used for S-Band in the future.
Extremely unlikely.

best regards,
-- 
Patrick.
