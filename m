Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay4.synopsys.com ([198.182.47.9]:34816 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753091AbdCOQvO (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 15 Mar 2017 12:51:14 -0400
Subject: Re: [PATCH v10 1/2] Documentation: DT: Add OV5647 bindings
To: Rob Herring <robh@kernel.org>,
        Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
References: <cover.1488798062.git.roliveir@synopsys.com>
 <e89902c0c99d0daf9ef821dd7a9c67e866b18a94.1488798062.git.roliveir@synopsys.com>
 <20170315164209.p24r7mpyijbxleja@rob-hp-laptop>
CC: <linux-kernel@vger.kernel.org>, <linux-media@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <vladimir_zapolskiy@mentor.com>,
        <CARLOS.PALMINHA@synopsys.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        "Hans Verkuil" <hans.verkuil@cisco.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pavel Machek <pavel@ucw.cz>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Steve Longerbeam <slongerbeam@gmail.com>
From: Ramiro Oliveira <Ramiro.Oliveira@synopsys.com>
Message-ID: <0e89fb01-ce6f-5d61-4da9-fc93c1805c34@synopsys.com>
Date: Wed, 15 Mar 2017 16:51:02 +0000
MIME-Version: 1.0
In-Reply-To: <20170315164209.p24r7mpyijbxleja@rob-hp-laptop>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Rob

On 3/15/2017 4:42 PM, Rob Herring wrote:
> On Mon, Mar 06, 2017 at 11:16:33AM +0000, Ramiro Oliveira wrote:
>> Create device tree bindings documentation.
>>
>> Signed-off-by: Ramiro Oliveira <roliveir@synopsys.com>
>> ---
>>  .../devicetree/bindings/media/i2c/ov5647.txt       | 35 ++++++++++++++++++++++
>>  1 file changed, 35 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/media/i2c/ov5647.txt
> 
> There's no changelog here, so I can't tell if anything is changed, but I 
> acked v7. Please add acks when sending new versions.
> 

The changelog is in the cover letter, although I didn't specify which changes
where made in the driver and which were made in the Documentation.

The only change was removing the clock name since there was only one clock used.

Should I keep your ack?

-- 
Best Regards

Ramiro Oliveira
Ramiro.Oliveira@synopsys.com
