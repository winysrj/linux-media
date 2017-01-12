Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:33866 "EHLO
        relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750791AbdALXnz (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 12 Jan 2017 18:43:55 -0500
Subject: Re: [PATCH v2 00/21] Basic i.MX IPUv3 capture support
To: Philipp Zabel <p.zabel@pengutronix.de>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
 <20161019213026.GU9460@valkosipuli.retiisi.org.uk>
 <CAH-u=807nRYzza0kTfOMv1AiWazk6FGJyz6W5_bYw7v9nOrccA@mail.gmail.com>
 <20161229205113.j6wn7kmhkfrtuayu@pengutronix.de>
 <7350daac-14ee-74cc-4b01-470a375613a3@denx.de>
 <c38d80aa-5464-1e9d-e11a-f54716fdb565@mentor.com>
 <1483990983.13625.58.camel@pengutronix.de>
 <43564c16-f7aa-2d35-a41f-991465faaf8b@mentor.com>
 <5b4bb7bd-83ae-c1f3-6b24-989dd6b0aa48@mentor.com>
 <1484136644.2934.89.camel@pengutronix.de>
 <8e6092a3-d80b-fe01-11b4-fbebe1de3102@mentor.com>
CC: Marek Vasut <marex@denx.de>,
        Robert Schwebel <r.schwebel@pengutronix.de>,
        Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
From: Steve Longerbeam <steve_longerbeam@mentor.com>
Message-ID: <d8001f56-7e5b-7b23-1dc2-0c3cef5b6ceb@mentor.com>
Date: Thu, 12 Jan 2017 15:43:51 -0800
MIME-Version: 1.0
In-Reply-To: <8e6092a3-d80b-fe01-11b4-fbebe1de3102@mentor.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 01/12/2017 03:22 PM, Steve Longerbeam wrote:
>
>
>>> and since my PRPVF entity roles
>>> up the VDIC internally, it is actually receiving from the VDIC channel.
>>> So unless you think we should have a distinct VDIC entity, I would like
>>> to keep this
>>> the way it is.
>> Yes, I think VDIC should be separated out of PRPVF. What do you think
>> about splitting the IC PRP into three parts?
>>
>> PRP could have one input pad connected to either CSI0, CSI1, or VDIC,
>> and two output pads connected to PRPVF and PRPENC, respectively. This
>> would even allow to have the PRP describe the downscale and PRPVF and
>> PRPENC describe the bilinear upscale part of the IC.

Actually, how about the following:

PRP would have one input pad coming from CSI0, CSI1, or VDIC. But
instead of another level of indirection with two more PRPENC and PRPVF
entities, PRP would instead have two output pads, one for PRPVF output
and one for PRPENC output.

Both output pads could be activated if the input is connected to CSI0 or 
CSI1.
And only the PRPVF output can be activated if the input is from VDIC.

Steve

