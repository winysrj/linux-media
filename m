Return-path: <linux-media-owner@vger.kernel.org>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:44293 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752795Ab2HALG7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 1 Aug 2012 07:06:59 -0400
References: <50186040.1050908@lockie.ca>
In-Reply-To: <50186040.1050908@lockie.ca>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: 3.5 kernel options for Hauppauge_WinTV-HVR-1250
From: Andy Walls <awalls@md.metrocast.net>
Date: Wed, 01 Aug 2012 07:07:08 -0400
To: James <bjlockie@lockie.ca>,
	linux-media Mailing List <linux-media@vger.kernel.org>
Message-ID: <c5ac2603-cc98-4688-b50c-b9166cada8f0@email.android.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

James <bjlockie@lockie.ca> wrote:

>I got the latest kernel from git and I can't find the kernel options
>for my tv card.
>
>I have: http://linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-1250
>--
>To unsubscribe from this list: send the line "unsubscribe linux-media"
>in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

/sbin/modinfo cx23885

Regards,
Andy
