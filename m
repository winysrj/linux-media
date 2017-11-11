Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:37599 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751354AbdKKMEr (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 11 Nov 2017 07:04:47 -0500
Received: by mail-wm0-f65.google.com with SMTP id b14so7111554wme.2
        for <linux-media@vger.kernel.org>; Sat, 11 Nov 2017 04:04:46 -0800 (PST)
Received: from [192.168.0.22] ([62.147.246.169])
        by smtp.googlemail.com with ESMTPSA id m8sm10013159edl.74.2017.11.11.04.04.44
        for <linux-media@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Nov 2017 04:04:44 -0800 (PST)
Subject: Re: [PATCH 2/2] sdlcam: ignore binary
From: =?UTF-8?B?UmFmYcOrbCBDYXJyw6k=?= <funman@videolan.org>
To: linux-media@vger.kernel.org
References: <20171110160547.32639-1-funman@videolan.org>
 <20171110160547.32639-2-funman@videolan.org>
Message-ID: <74120e78-9c30-77f2-43c9-75a58efbf25f@videolan.org>
Date: Sat, 11 Nov 2017 13:04:44 +0100
MIME-Version: 1.0
In-Reply-To: <20171110160547.32639-2-funman@videolan.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/10/2017 05:05 PM, Rafaël Carré wrote:
> ---
>  contrib/test/.gitignore | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/contrib/test/.gitignore b/contrib/test/.gitignore
> index ad64325b..5bd81d01 100644
> --- a/contrib/test/.gitignore
> +++ b/contrib/test/.gitignore
> @@ -8,3 +8,4 @@ stress-buffer
>  v4l2gl
>  v4l2grab
>  mc_nextgen_test
> +sdlcam
> 

Signed-off-by: Rafaël Carré <funman@videolan.org>
