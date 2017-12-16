Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f171.google.com ([74.125.82.171]:36098 "EHLO
        mail-ot0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753577AbdLPSiW (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 16 Dec 2017 13:38:22 -0500
Date: Sat, 16 Dec 2017 12:38:20 -0600
From: Rob Herring <robh@kernel.org>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-devicetree <devicetree@vger.kernel.org>
Subject: Re: [PATCH for v4.15] dt-bindings/media/cec-gpio.txt: mention the
 CEC/HPD max voltages
Message-ID: <20171216183820.wvlktltzfjidlbeq@rob-hp-laptop>
References: <064113a5-f8be-5b10-091f-a89b87baa5a3@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <064113a5-f8be-5b10-091f-a89b87baa5a3@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Dec 16, 2017 at 11:44:13AM +0100, Hans Verkuil wrote:
> Mention the maximum voltages of the CEC and HPD lines. Since in the example
> these lines are connected to a Raspberry Pi and the Rpi GPIO lines are 3.3V
> it is a good idea to warn against directly connecting the HPD to the Raspberry
> Pi's GPIO line.
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>

Reviewed-by: Rob Herring <robh@kernel.org>
