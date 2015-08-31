Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:38874 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbbHaRqF (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 31 Aug 2015 13:46:05 -0400
Subject: Re: [PATCH] media: dvb-core: Don't force CAN_INVERSION_AUTO in
 oneshot mode.
To: Johann Klammer <klammerj@a1.net>, linux-media@vger.kernel.org
References: <1441012425-25050-1-git-send-email-tvboxspy@gmail.com>
 <55E488FF.3040608@a1.net>
Cc: stable@vger.kernel.org
From: Malcolm Priestley <tvboxspy@gmail.com>
Message-ID: <55E492B8.4020207@gmail.com>
Date: Mon, 31 Aug 2015 18:45:28 +0100
MIME-Version: 1.0
In-Reply-To: <55E488FF.3040608@a1.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 31/08/15 18:03, Johann Klammer wrote:
>
> Why not just remove the line?
> 	info->caps |= FE_CAN_INVERSION_AUTO;
>
> The capabilities call interacting with the oneshot setting is rather weird and maybe unexpected.
>
>

No, because in normal mode it can do auto inversion.
