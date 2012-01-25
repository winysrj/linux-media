Return-path: <linux-media-owner@vger.kernel.org>
Received: from thor.websupport.sk ([195.210.28.15]:53934 "EHLO
	thor.websupport.sk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab2AYR6M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 25 Jan 2012 12:58:12 -0500
Message-ID: <4F20429F.6030003@maindata.sk>
Date: Wed, 25 Jan 2012 18:57:51 +0100
From: Marek Ochaba <ochaba@maindata.sk>
MIME-Version: 1.0
To: Kovacs Balazs <basq@bitklub.hu>
CC: linux-media@vger.kernel.org
Subject: Re: CI/CAM support for offline (from file) decoding
References: <18710154015.20120125181510@bitklub.hu>
In-Reply-To: <18710154015.20120125181510@bitklub.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I think more feasible way (than using linux kernel DVB layer) is using
SoftwareCAM with SmartCard reader. Some solution should be also implemented
in STB, which save records in encrypted state.

--
Marek Ochaba
