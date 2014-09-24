Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:35399 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872AbaIXENW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 24 Sep 2014 00:13:22 -0400
Received: by mail-pd0-f180.google.com with SMTP id r10so7641415pdi.25
        for <linux-media@vger.kernel.org>; Tue, 23 Sep 2014 21:13:22 -0700 (PDT)
Message-ID: <542244DA.1010508@gmail.com>
Date: Wed, 24 Sep 2014 13:13:14 +0900
From: Akihiro TSUKADA <tskd08@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH] [media] tc90522: declare tc90522_functionality as static
References: <5b2f265c143c9e8ee35b035de7d35bb69871fd84.1411502537.git.mchehab@osg.samsung.com>
In-Reply-To: <5b2f265c143c9e8ee35b035de7d35bb69871fd84.1411502537.git.mchehab@osg.samsung.com>
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Sorry to bother you with those build warnings.
Somehow I didn't see them when I built the modules myself on 64bit box.
maybe since I forgot to test all-y config (and 32bit build),
the gcc cmd did not include [-Wmissing-prototypes].

