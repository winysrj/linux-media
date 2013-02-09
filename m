Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:51680 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982Ab3BIWwI (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sat, 9 Feb 2013 17:52:08 -0500
Message-ID: <5116D313.8000603@gmail.com>
Date: Sat, 09 Feb 2013 23:52:03 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	linux-media@vger.kernel.org, kyungmin.park@samsung.com,
	kgene.kim@samsung.com, rob.herring@calxeda.com,
	prabhakar.lad@ti.com, devicetree-discuss@lists.ozlabs.org,
	linux-samsung-soc@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 02/10] s5p-fimc: Add device tree support for FIMC devices
References: <1359745771-23684-1-git-send-email-s.nawrocki@samsung.com> <1359745771-23684-3-git-send-email-s.nawrocki@samsung.com> <5112E9EF.8090908@wwwdotorg.org> <5115874A.6050406@gmail.com> <51158873.3060508@wwwdotorg.org> <511592B4.5050406@gmail.com> <5115991E.7050009@wwwdotorg.org> <5116CDBB.4080807@gmail.com>
In-Reply-To: <5116CDBB.4080807@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 02/09/2013 11:29 PM, Sylwester Nawrocki wrote:
>
>> After all, what happens in some later SoC where you have two different
>> types of module that feed into the common module, such that type A
>> sources have IDs 0..3 in the common module, and type B sources have IDs
>> 4..7 in the common module - you wouldn't want to require alias ISs 4..7
>> for the type B DT nodes.

I forgot to add, any ID remapping could happen in the common module, if
it requires it. Type A and type B sources could have indexes 0...3 and
the common module could derive its configuration from the source ID *and*
the source type. The idea behind aliases was to identify each instance,
rather than providing an exact configuration data that the common module
could use.
