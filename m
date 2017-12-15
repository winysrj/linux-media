Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtprelay2.synopsys.com ([198.182.60.111]:49156 "EHLO
        smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753279AbdLOLXL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 15 Dec 2017 06:23:11 -0500
Subject: Re: [PATCH v10 4/4] [media] platform: Add Synopsys DesignWare HDMI RX
 Controller Driver
To: Hans Verkuil <hverkuil@xs4all.nl>, <linux-media@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <cover.1513013948.git.joabreu@synopsys.com>
 <5f9eedfd6f91ed73ef0bb6d3977588d01478909f.1513013948.git.joabreu@synopsys.com>
 <108e2c3c-243f-cd67-2df7-57541b28ca39@xs4all.nl>
 <635e7d70-0edb-7506-c268-9ebbae1eb39e@synopsys.com>
 <ca5b3cf7-c7d0-36d4-08ac-32a7a00afd7d@xs4all.nl>
 <f5341c4b-43e2-12f6-9c9f-2385d47bb2fd@synopsys.com>
 <86a5787d-6ed6-7674-35f9-c77341b4c36b@xs4all.nl>
CC: Joao Pinto <Joao.Pinto@synopsys.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        "Sylwester Nawrocki" <snawrocki@kernel.org>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Philippe Ombredanne <pombredanne@nexb.com>
From: Jose Abreu <Jose.Abreu@synopsys.com>
Message-ID: <3c15b537-33b3-f786-369e-5d82ab9eeb9c@synopsys.com>
Date: Fri, 15 Dec 2017 11:23:04 +0000
MIME-Version: 1.0
In-Reply-To: <86a5787d-6ed6-7674-35f9-c77341b4c36b@xs4all.nl>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 13-12-2017 20:49, Hans Verkuil wrote:
> On 13/12/17 15:00, Jose Abreu wrote:
>>
>> Indeed. I compared the values with the spec and they are not
>> correct. Even hsync is wrong. I already corrected in the code the
>> hsync but regarding interlace I'm not seeing an easy way to do
>> this without using interrupts in each vsync because the register
>> I was toggling does not behave as I expected (I misunderstood the
>> databook). Maybe we should not detect interlaced modes for now?
>> Or not fill the il_ fields?
> As I mentioned above you as long as you get a good backporch value you
> can deduce from whether it is an odd or even number to which field it
> belongs and fill in the other values. So I think you only need to read
> these values for one field.
>
> Filling in good values here (at least as far as is possible since not all
> hardware can give it) will help debugging issues, even if you otherwise do
> not support interlaced.

Ok, I will fill the fields.

Until the end of January I will be quite busy in another project
so if you could review the remaining patches of this series I
would appreciate very much ... This way when I have the time I
can code all the changes and send them at once.

Thanks and Best Regards,
Jose Miguel Abreu

>
> Regards,
>
> 	Hans
