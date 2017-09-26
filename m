Return-path: <linux-media-owner@vger.kernel.org>
Received: from unicorn.mansr.com ([81.2.72.234]:56068 "EHLO unicorn.mansr.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966076AbdIZOta (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 26 Sep 2017 10:49:30 -0400
From: =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To: Marc Gonzalez <marc_gonzalez@sigmadesigns.com>
Cc: Sean Young <sean@mess.org>,
        linux-media <linux-media@vger.kernel.org>,
        Mason <slash.tmp@free.fr>
Subject: Re: [PATCH v6 2/2] media: rc: Add driver for tango HW IR decoder
References: <308711ef-0ba8-d533-26fd-51e5b8f32cc8@free.fr>
        <e3d91250-e6bd-bb8c-5497-689c351ac55f@free.fr>
        <yw1xzi9ieuqe.fsf@mansr.com>
        <893874ee-a6e0-e4be-5b4f-a49e60197e92@free.fr>
        <yw1xr2uuenhv.fsf@mansr.com>
        <0690fbbb-a13f-63af-bc43-b1f9d4771bc4@free.fr>
        <yw1xmv5hehp0.fsf@mansr.com>
        <ee434b81-3406-7ea0-3a54-b5dc1d6720c9@sigmadesigns.com>
Date: Tue, 26 Sep 2017 15:49:27 +0100
In-Reply-To: <ee434b81-3406-7ea0-3a54-b5dc1d6720c9@sigmadesigns.com> (Marc
        Gonzalez's message of "Tue, 26 Sep 2017 16:14:21 +0200")
Message-ID: <yw1xing5ecqw.fsf@mansr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Marc Gonzalez <marc_gonzalez@sigmadesigns.com> writes:

> On 26/09/2017 15:02, Måns Rullgård wrote:
>
>> I could continue nit-picking, but I think this is good enough.
>> Thanks for being patient.
>> 
>> Signed-off-by: Mans Rullgard <mans@mansr.com>
>
> Smirk.
>
> If you feel like making a final round of changes on top of this patch,
> then go for it. It's your code, after all.
>
> (Too bad there is no devm variant of clk_prepare_enable.)
>
> Does it make sense to submit a keymap for the Sigma remote control
> used with Vantage boards? And define that as the default keymap?

Maybe.  The real product I have with a tango3 chip uses a remote control
that is quite similar the Sigma one.  Having something that works out of
the box with the dev board is also nice.

-- 
Måns Rullgård
