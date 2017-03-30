Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-2.goneo.de ([85.220.129.31]:43760 "EHLO smtp1.goneo.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753965AbdC3Lfw (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 30 Mar 2017 07:35:52 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 02/22] docs-rst: convert usb docbooks to ReST
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <318BAC09-137D-4EA6-B2E9-C5BF0E01A769@darmarit.de>
Date: Thu, 30 Mar 2017 13:35:07 +0200
Cc: Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        John Youn <johnyoun@synopsys.com>, linux-usb@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Takashi Iwai <tiwai@suse.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Oliver Neukum <oneukum@suse.com>,
        Martyn Welch <martyn.welch@collabora.co.uk>,
        Alexander Dahl <post@lespocky.de>,
        Jonathan Cameron <jic23@kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <021E49F6-54B8-4413-8299-98A7731125C3@darmarit.de>
References: <4f2a7480ba9a3c89e726869fddf17e31cf82b3c7.1490813422.git.mchehab@s-opensource.com> <327dcce56a725c7f91f542f2ff97995504d26526.1490813422.git.mchehab@s-opensource.com> <7D76BCB2-53F5-4BD4-8205-5A4852164C91@darmarit.de> <87y3vn2mzk.fsf@intel.com> <D5D8BF1C-755B-4D56-B744-6A155C5B2313@darmarit.de> <20170330071258.0ca47e4c@vento.lan> <318BAC09-137D-4EA6-B2E9-C5BF0E01A769@darmarit.de>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 30.03.2017 um 13:17 schrieb Markus Heiser <markus.heiser@darmarIT.de>:
> 
> If it helps ... dbxml2rst also supports single file conversion  ... I updated:
> 
>  https://github.com/return42/sphkerneldoc/tree/master/Documentation/books_migrated
> 
> There you find a folder for each DocBook conversion with only one rst file (index.rst)
> in .. If you like, use it for comparison.

Forget to mentioning one of the main benefits: 

The conversion with dbxml2rst produce tables with directive ".. flat-table::"
instead of building ASCII tables (like pandoc does).

-- Markus --
