Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:37020 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471AbZFZSgS (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 26 Jun 2009 14:36:18 -0400
Received: by ewy6 with SMTP id 6so3643644ewy.37
        for <linux-media@vger.kernel.org>; Fri, 26 Jun 2009 11:36:20 -0700 (PDT)
To: Chaithrika U S <chaithrika@ti.com>
Cc: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	Manjunath Hadli <mrh@ti.com>, Brijesh Jadav <brijesh.j@ti.com>
Subject: Re: [PATCH] Subject: [PATCH v3 1/4] ARM: DaVinci: DM646x Video: Platform and board specific setup
References: <1241789157-23350-1-git-send-email-chaithrika@ti.com>
	<87ljneeti5.fsf@deeprootsystems.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Fri, 26 Jun 2009 11:36:14 -0700
In-Reply-To: <87ljneeti5.fsf@deeprootsystems.com> (Kevin Hilman's message of "Fri\, 26 Jun 2009 11\:32\:02 -0700")
Message-ID: <87d48qetb5.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Kevin Hilman <khilman@deeprootsystems.com> writes:

> Chaithrika U S <chaithrika@ti.com> writes:
>
>> Platform specific display device setup for DM646x EVM
>>
>> Add platform device and resource structures. Also define a platform specific
>> clock setup function that can be accessed by the driver to configure the clock
>> and CPLD.
>>
>> This patch is dependent on a patch submitted earlier, which adds
>> Pin Mux and clock definitions for Video on DM646x.
>>
>> Signed-off-by: Manjunath Hadli <mrh@ti.com>
>> Signed-off-by: Brijesh Jadav <brijesh.j@ti.com>
>> Signed-off-by: Chaithrika U S <chaithrika@ti.com>
>> ---
>> Applies to Davinci GIT tree
>
> Needs an update to apply to current linus or davinci git.

Please ignore this review, I see there was a newer version posted.
Will review shortly.

Sorry for the confusion.

Kevin

