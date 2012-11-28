Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:44790 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754744Ab2K1NNd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 28 Nov 2012 08:13:33 -0500
Received: by mail-ie0-f174.google.com with SMTP id k11so10005883iea.19
        for <linux-media@vger.kernel.org>; Wed, 28 Nov 2012 05:13:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <50B60D54.4010302@interlinx.bc.ca>
References: <k93vu3$ffi$1@ger.gmane.org>
	<CALF0-+VkANRj+by2n-=UsxZfJwk97ZkNS8R0C-Vt2oX7WN3R0A@mail.gmail.com>
	<50B60D54.4010302@interlinx.bc.ca>
Date: Wed, 28 Nov 2012 10:13:32 -0300
Message-ID: <CALF0-+UHOJDh471aa7URKr1-xbggrbDdg_nDijv2FOUpo=3zaw@mail.gmail.com>
Subject: Re: ivtv driver inputs randomly "block"
From: Ezequiel Garcia <elezegarcia@gmail.com>
To: "Brian J. Murrell" <brian@interlinx.bc.ca>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Nov 28, 2012 at 10:10 AM, Brian J. Murrell
<brian@interlinx.bc.ca> wrote:
> On 12-11-28 08:08 AM, Ezequiel Garcia wrote:
>>
>> Can you post a dmesg output when this happens?
>
> Unfortunately, there is nothing at all in dmesg when this happens.
>

Try again with
modprobe ivtv ivtv_debug=10
