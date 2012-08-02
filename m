Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:34277 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753166Ab2HBKwX (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 2 Aug 2012 06:52:23 -0400
Received: by mail-lpp01m010-f46.google.com with SMTP id d3so5219225lah.19
        for <linux-media@vger.kernel.org>; Thu, 02 Aug 2012 03:52:23 -0700 (PDT)
Message-ID: <501A5BB0.4090809@mvista.com>
Date: Thu, 02 Aug 2012 14:51:28 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
MIME-Version: 1.0
To: Dror Cohen <dror@liveu.tv>
CC: linux-media@vger.kernel.org,
	davinci-linux-open-source@linux.davincidsp.com,
	mchehab@infradead.org
Subject: Re: [PATCH 0/1] media/video: vpif: fixing function name start to
 vpif_config_params
References: <1343893232-19543-1-git-send-email-dror@liveu.tv>
In-Reply-To: <1343893232-19543-1-git-send-email-dror@liveu.tv>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello.

On 02-08-2012 11:40, Dror Cohen wrote:

> This patch address the issue that a function named config_vpif_params should
> be vpif_config_params. This, however, conflicts with two structures defined
> already.

    Function names shouldn't conflict with the structure tags. Structure tags 
always follow 'struct' keyword and are only valid in this context.

> So I changed the structures to config_vpif_params_t (origin was
> vpif_config_params)

WBR, Sergei

