Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:33335 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932511AbbFJHcW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2015 03:32:22 -0400
Received: by wiwd19 with SMTP id d19so38990170wiw.0
        for <linux-media@vger.kernel.org>; Wed, 10 Jun 2015 00:32:21 -0700 (PDT)
Message-ID: <5577E803.90504@gmail.com>
Date: Wed, 10 Jun 2015 08:32:19 +0100
From: Jemma Denson <jdenson@gmail.com>
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
CC: Patrick Boettcher <patrick.boettcher@posteo.de>,
	linux-media@vger.kernel.org
Subject: Re: [PATCH 3/4] cx24120: Take control of b2c2 receive stream
References: <1432326508-6825-1-git-send-email-jdenson@gmail.com>	<1432326508-6825-4-git-send-email-jdenson@gmail.com>	<20150526110545.32c71335@dibcom294.coe.adi.dibcom.com>	<55643B07.9010807@gmail.com> <20150609205632.007e68d5@recife.lan>
In-Reply-To: <20150609205632.007e68d5@recife.lan>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 10/06/15 00:56, Mauro Carvalho Chehab wrote:
> Hmm... if patch 1 is enough to fix the issue, and patch 4 may break 
> things, I'll apply only patch 1/4 for now. If Patrick agrees, and you 
> find a way to avoid breakages, please resubmit for me to apply the 
> other ones. Regards, Mauro 

I already posted a v2 of this patch series which does the stream control 
in a much better way - that v2 version has been running on my mythtv 
recording box for a few weeks now without issue.

Jemma.
