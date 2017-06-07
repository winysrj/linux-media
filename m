Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ot0-f178.google.com ([74.125.82.178]:34888 "EHLO
        mail-ot0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751536AbdFGATR (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Tue, 6 Jun 2017 20:19:17 -0400
Received: by mail-ot0-f178.google.com with SMTP id a2so24537648oth.2
        for <linux-media@vger.kernel.org>; Tue, 06 Jun 2017 17:19:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <519d0131-b9a7-4afa-78d4-8bb6dccec1ad@xs4all.nl>
References: <20170602213431.10777-1-khilman@baylibre.com> <519d0131-b9a7-4afa-78d4-8bb6dccec1ad@xs4all.nl>
From: Kevin Hilman <khilman@baylibre.com>
Date: Tue, 6 Jun 2017 17:19:16 -0700
Message-ID: <CAOi56cX2wUvMOoCAGnay0b6weTSuS1+xeO2V7pryfe+aM3Jq8w@mail.gmail.com>
Subject: Re: [PATCH 0/4] [media] davinci: vpif_capture: raw camera support
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 6, 2017 at 1:34 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> Hi Kevin,
>
> On 02/06/17 23:34, Kevin Hilman wrote:
>> This series fixes/updates the support for raw camera input to the VPIF.
>>
>> Tested on da850-evm boards using the add-on UI board.  Tested with
>> both composite video input (on-board tvp514x) and raw camera input
>> using the camera board from On-Semi based on the aptina,mt9v032
>> sensor[1], as this was the only camera board with the right connector
>> for the da850-evm UI board.
>>
>> Verified that composite video capture is still working well after these
>> updates.
>
> Can you rebase this patch series against the latest media master branch?
>
> Mauro merged a lot of patches, in particular the one switching v4l2_of_ to
> v4l2_fwnode_. And that conflicts with patches 2 and 4.

Rebased and resent as v2.

Kevin
