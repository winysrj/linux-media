Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44843 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab3LQU7N (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Dec 2013 15:59:13 -0500
Message-ID: <52B0BB1F.9070506@iki.fi>
Date: Tue, 17 Dec 2013 22:59:11 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
CC: Martin Bugge <marbugge@cisco.com>,
	Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [RFC PATCH 24/22] adv7842: set LLC DLL phase from platform_data
References: <1386687848-21265-1-git-send-email-hverkuil@xs4all.nl> <9e9eaa702db4b0e0626dbf7200578e66d8281312.1386687810.git.hans.verkuil@cisco.com> <52B04EE8.7040707@xs4all.nl>
In-Reply-To: <52B04EE8.7040707@xs4all.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 17.12.2013 15:17, Hans Verkuil wrote:
> The correct LLC DLL phase depends on the board layout, so this
> should be part of the platform_data.
>
> Verified-by: Martin Bugge <marbugge@cisco.com>

Nit, but the documentation says correct tag is Tested-by :)

regards
Antti

-- 
http://palosaari.fi/
