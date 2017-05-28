Return-path: <linux-media-owner@vger.kernel.org>
Received: from www.llwyncelyn.cymru ([82.70.14.225]:44856 "EHLO fuzix.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750802AbdE1UAh (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 28 May 2017 16:00:37 -0400
Date: Sun, 28 May 2017 21:00:25 +0100
From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
To: Hans de Goede <hdegoede@redhat.com>
Cc: Lee Jones <lee.jones@linaro.org>, Chen-Yu Tsai <wens@csie.org>,
        linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH v5 2/7] staging: atomisp: Do not call dev_warn with a
 NULL device
Message-ID: <20170528210025.0062014d@alans-desktop>
In-Reply-To: <508ccb9b-fcde-b040-593d-5e8552db5f24@redhat.com>
References: <20170528123040.18555-1-hdegoede@redhat.com>
        <20170528123040.18555-2-hdegoede@redhat.com>
        <20170528180853.5a6c8f11@alans-desktop>
        <508ccb9b-fcde-b040-593d-5e8552db5f24@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> The code for the special v1p8 / v2p8 gpios is ugly as sin, it operates on
> a global v2p8_gpio value rather then storing info in the gmin_subdev struct,
> as such passing the subdev->dev pointer would be simply wrong. AFAICT the
> v1p8 / v2p8 gpio code is the only caller passing in a NULL pointer and
> as said since thisv1p8 / v2p8 gpio code is only for some special evaluation
> boards, silencing the error when these variables are not present actually
> is the right thing to do.

Unfortunately I don't think it is constrained to RVPs. As with all
developer hacks on code that isn't subject to public review at the time
they escape into the wild 8(

Agreed though. The patch makes sense if you don't want to print anything.

> > which if my understanding of the subdevices is correct should pass the
> > right valid device field from the atomisp.
> > 
> > Please also cc me if you are proposing patches this driver - and also
> > linux-media.  
> 
> Sorry about that, I messed up my git send-email foo and send this to
> a wrong set of addresses (and also added v5 in the subject which should
> not be there) I did send out a fresh-copy with the full 7 patch patch-set
> directly after CTRL+c-ing this wrong send-email (which only got the
> first 3 patches send).

So I discovered just afterwards 8)

Alan
