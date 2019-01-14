Return-Path: <SRS0=CLae=PW=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D72AC43387
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 09:52:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3625920656
	for <linux-media@archiver.kernel.org>; Mon, 14 Jan 2019 09:52:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F1dDc6LZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726572AbfANJwj (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 14 Jan 2019 04:52:39 -0500
Received: from mail-wr1-f53.google.com ([209.85.221.53]:38406 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726467AbfANJwj (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 14 Jan 2019 04:52:39 -0500
Received: by mail-wr1-f53.google.com with SMTP id v13so22036268wrw.5
        for <linux-media@vger.kernel.org>; Mon, 14 Jan 2019 01:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=Kt4hn5BS+trCPhor8daLLu9ORrj09bDMFCrZAXsIVqU=;
        b=F1dDc6LZ5dqP+F2Mj8j7GRlpUK/rWFgachOh+vbbeTx3ADD1QkHR8BRenfDMNyz0qF
         cPPwjxU92Esl5Q33d+jqcYC+u7afa9eKnoE/YA8MTpCqHl+SST6k6x6+sVqYwxCXgjVX
         FnP2Kk+MKd7WMIbSxUAtnPY+b5zAKWC69iugG1c/glF5eIcn7tfdB1Pq9sUJP8hgQNTS
         X5Wv+86d9ZP1Fl8xQHcP56x9asqC0wHktmhMCZuJo/Jsh1vRuFmPCHoNoF6dQNuhiOf/
         82RlRDh5JnWt3ifKPwMTUl0uXQxwkuvuslBv16moSmLVaRysoEflK/8TDghzI2PJZKHy
         favg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=Kt4hn5BS+trCPhor8daLLu9ORrj09bDMFCrZAXsIVqU=;
        b=GdZd/3tjP3mUJh4VIl0IhchHpY05yV6E6C+sB/AoVm4Nzk//N34FDXTmK4BzMCL70f
         SaYm6MaOjXV3v2qSi9mZH5Ke91jTvsFXmZ/XBxF66qdWvDhZs56GiXa1aIMjHU4DavjN
         uZaOoYWOTdJJXV45p7fO3rl2IiOuT0uM9pTSgJUF+JN7ex69BOlH28Jz2EeDlwDKQGWm
         zW8DY/9oltQXlRZTuLjXfKR0aRJ05Jcy9yU8B8NyMKVtyZv87lMJuOqhwO+Zv2pmA9zH
         LxpcXZdecT0aqW+gcbO+ipnsw+3nZq7Yf0kIjhBfwvOPw7TgFmBrFcAsFeNfZK7R4B8C
         uoAw==
X-Gm-Message-State: AJcUukeXhWa5Yz8lzzHKo4Q30MLQVrKL90Cx9lm8tmpj7uJn/so1raxg
        ItdfkJPiEaI9PhFLiZPXnxyj2nqSQ1KyTQJ1MHgs1RA8
X-Google-Smtp-Source: ALg8bN4+GVUbQqhbIwu/4I8TLgzWUTMx5AkMZabiw6BcwfT5rD2ggHLZU7ze2+IWyqYnLoqCVPPZZplDBP+T3E2WUcU=
X-Received: by 2002:a5d:63c3:: with SMTP id c3mr23194187wrw.215.1547459556970;
 Mon, 14 Jan 2019 01:52:36 -0800 (PST)
MIME-Version: 1.0
From:   Jean-Michel Hautbois <jhautbois@gmail.com>
Date:   Mon, 14 Jan 2019 10:52:25 +0100
Message-ID: <CAL8zT=j79yQ2=RfE2zVhM0o4Cck1xKTo9oUG73kiAExDvQkt7w@mail.gmail.com>
Subject: i.MX6 RAW8 format
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Philipp Zabel <p.zabel@pengutronix.de>,
        Steve Longerbeam <slongerbeam@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>, sakari.ailus@iki.fi
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Hi,

I am currently using an upstream kernel on a i.MX6 Quad board, and I
have a strange issue.
The device I am using is able to produce RGB888 MIPI data, or RAW8/RAW10.
The MIPI data types are respectively 0x24, 0x2A and 0x2B.
When I configure the device to produce RGB888 data, everything is
fine, but when I configure it to produce RAW8 data, then the pattern
is weird.

I am sending the following pattern :
0x11 0x22 0x33 0x44 0x55 0x66 0x77 0x88 0x99 0xAA 0xBB 0xCC 0xDD 0xEE
0x11 0x22 0x33 0x44 0x55 0x66...
And I get in a raw file :
0x11 0x22 0x33 0x44 0x55 0x66 0x77 0x88 0x33 0x44 0x55 0x66 0x77 0x88 0x99 =
...
The resulting raw file has the correct size (ie. 1280x720 bytes).

I could get a logic analyzer able to decode MIPI-CSI2 protocol, and on
this side, the pattern is complete, no data is lost, and the Datatype
is 0x2A.
It really looks like an issue on the i.MX6 side.

So, looking at it, I would say than for each 8 bytes captured, a jump
of 8 bytes is done ?
The media-ctl is configured like this :
media-ctl -l "'ds90ub954 2-0034':0 -> 'imx6-mipi-csi2':0[1]" -v
media-ctl -l "'imx6-mipi-csi2':1 -> 'ipu1_csi0_mux':0[1]" -v
media-ctl -l "'ipu1_csi0_mux':2 -> 'ipu1_csi0':0[1]" -v
media-ctl -l "'ipu1_csi0':2 -> 'ipu1_csi0 capture':0[1]"
media-ctl -V "'ds90ub954 2-0034':0 [fmt:SBGGR8_1X8/1280x720 field:none]"
media-ctl -V "'imx6-mipi-csi2':1 [fmt:SBGGR8_1X8/1280x720 field:none]"
media-ctl -V "'ipu1_csi0_mux':2 [fmt:SBGGR8_1X8/1280x720 field:none]"
media-ctl -V "'ipu1_csi0':2 [fmt:SBGGR8_1X8/1280x720 field:none]"

The ds90ub954 driver I wrote is very dump and just used to give I=C2=B2C
access and configure the deserializer to produce the pattern.
I also tried to use a camera, which produces RAW8 data, but the result
is the same, I don't get all my bytes, at least, not in the correct
order.

And the command used to capture a file is :
v4l2-ctl -d4 --set-fmt-video=3Dwidth=3D1280,height=3D720,pixelformat=3DBA81
--stream-mmap --stream-count=3D1 --stream-to=3D/root/cam.raw

I can send the raw file if it is needed.
I tried several configurations, changing the number of lanes, the
frequency, etc. but I have the same behaviour.

So, I am right now stuck with this, as I can't see anything which
could explain this. IC burst ? Something else ?

Thanks a lot,
JM
