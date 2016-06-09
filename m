Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:40995 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbcFIUZF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 9 Jun 2016 16:25:05 -0400
Subject: Re: dvb-core: how should i2c subdev drivers be attached?
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
References: <52775753-47c4-bfdf-b8f5-48bdf8ceb6e5@gmail.com>
 <20160609122449.5cfc16cc@recife.lan>
 <07669546-908f-f81c-26e5-af7b720229b3@iki.fi>
 <20160609131813.710e1ab2@recife.lan>
 <f89f96f0-40a3-6e50-5d83-0cfaf50e8089@iki.fi>
 <20160609153015.108e4d98@recife.lan>
 <a67edaab-4da2-6ccf-9b2a-08f95cc1072e@iki.fi>
 <20160609163528.67394569@recife.lan>
Cc: Akihiro TSUKADA <tskd08@gmail.com>, linux-media@vger.kernel.org
From: Antti Palosaari <crope@iki.fi>
Message-ID: <0b4f28aa-acac-ae52-3593-27ac97e91c95@iki.fi>
Date: Thu, 9 Jun 2016 23:24:59 +0300
MIME-Version: 1.0
In-Reply-To: <20160609163528.67394569@recife.lan>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/09/2016 10:35 PM, Mauro Carvalho Chehab wrote:
> The above code is racy, as some other request to the frontend
> may arrive between the if() statement and kfree(). A kref would
> likely be safer.

Here is working proof-of-concept hack. It is for si2157 tuner module. It 
prevents module unbind and unload when module is active. Of course it is 
not safe. Some more work needed in order to allow runtime bind (I tested 
it earlier with a8293 and unbind + bind was possible for deactive module 
at that time).

https://git.linuxtv.org/anttip/media_tree.git/log/?h=unbind_poc

regards
Antti

-- 
http://palosaari.fi/
