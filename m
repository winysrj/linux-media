Return-path: <linux-media-owner@vger.kernel.org>
Received: from galahad.ideasonboard.com ([185.26.127.97]:37868 "EHLO
        galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750779AbeAPO4F (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 16 Jan 2018 09:56:05 -0500
Subject: Re: [RFT PATCH v3 0/6] Asynchronous UVC
To: Philipp Zabel <philipp.zabel@gmail.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Olivier BRAUN <olivier.braun@stereolabs.com>,
        Troy Kisky <troy.kisky@boundarydevices.com>
References: <cover.30aaad9a6abac5e92d4a1a0e6634909d97cc54d8.1515748369.git-series.kieran.bingham@ideasonboard.com>
 <CA+gwMcfh0Oc53TZLc=_xtFJrqfw8s0gjD9mfPFZ_Cp9=vMAMDQ@mail.gmail.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <03c7a709-7a9a-3921-844b-d4d91b7e70c4@ideasonboard.com>
Date: Tue, 16 Jan 2018 14:55:55 +0000
MIME-Version: 1.0
In-Reply-To: <CA+gwMcfh0Oc53TZLc=_xtFJrqfw8s0gjD9mfPFZ_Cp9=vMAMDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Phillip

On 15/01/18 19:35, Philipp Zabel wrote:
> Hi Kieran,
> 
> On Fri, Jan 12, 2018 at 10:19 AM, Kieran Bingham
> <kieran.bingham@ideasonboard.com> wrote:
>> This series has been tested on both the ZED and BRIO cameras on arm64
>> platforms, however due to the intrinsic changes in the driver I would like to
>> see it tested with other devices and other platforms, so I'd appreciate if
>> anyone can test this on a range of USB cameras.
> 
> FWIW,
> 
> Tested-by: Philipp Zabel <philipp.zabel@gmail.com>
> 
> with a Lite-On internal Laptop Webcam, Logitech C910 (USB2 isoc),
> Oculus Sensor (USB3 isoc), and Microsoft HoloLens Sensors (USB3 bulk).

Thank you, that is very much appreciated!

I presume that was on x86_64?

--
Regards

Kieran
