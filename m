Return-path: <linux-media-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:45300 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934568AbcHBPkp (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 2 Aug 2016 11:40:45 -0400
Subject: Re: [PATCH 0947/1285] Replace numeric parameter like 0444 with macro
To: Mauro Carvalho Chehab <maurochehab@gmail.com>,
	Baole Ni <baolex.ni@intel.com>
References: <20160802120134.13166-1-baolex.ni@intel.com>
 <20160802095118.47dcc5a6@recife.lan>
Cc: devel@driverdev.osuosl.org, k.kozlowski@samsung.com,
	mchehab@redhat.com, arnd@arndb.de, gregkh@linuxfoundation.org,
	linux-media@vger.kernel.org, mchehab@infradead.org,
	hverkuil@xs4all.nl, kyungmin.park@samsung.com,
	m.szyprowski@samsung.com, chuansheng.liu@intel.com,
	mchehab@kernel.org, linux-kernel@vger.kernel.org,
	m.chehab@samsung.com
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <bc61742b-1a7d-ae1f-da8b-dc7888773677@infradead.org>
Date: Tue, 2 Aug 2016 08:00:54 -0700
MIME-Version: 1.0
In-Reply-To: <20160802095118.47dcc5a6@recife.lan>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 08/02/16 05:51, Mauro Carvalho Chehab wrote:
> Em Tue,  2 Aug 2016 20:01:34 +0800
> Baole Ni <baolex.ni@intel.com> escreveu:
> 
>> I find that the developers often just specified the numeric value
>> when calling a macro which is defined with a parameter for access permission.
>> As we know, these numeric value for access permission have had the corresponding macro,
>> and that using macro can improve the robustness and readability of the code,
>> thus, I suggest replacing the numeric parameter with the macro.
> 
> Gah!
> 
> A patch series with 1285 patches with identical subject!
> 
> Please don't ever do something like that. My inbox is not trash!
> 
> Instead, please group the changes per subsystem, and use different
> names for each patch. Makes easier for people to review.
> 
> also, you need to send the patches to the subsystem mainatiner, and
> not adding a random list of people like this:
> 
> To: gregkh@linuxfoundation.org, maurochehab@gmail.com, mchehab@infradead.org, mchehab@redhat.com, m.chehab@samsung.com, m.szyprowski@samsung.com, kyungmin.park@samsung.com, k.kozlowski@samsung.com
> 
> Btw, use *just* the more recent email of the maintainer, instead of
> spamming trash to all our emails (even to the ones that we don't use
> anymore!
> 
> I'll just send all those things to /dev/null until you fix your
> email sending process.
>
+1285

There are people at Intel who know about things like this.

-- 
~Randy
