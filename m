Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36209 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755663AbdABTTl (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Mon, 2 Jan 2017 14:19:41 -0500
Received: by mail-oi0-f67.google.com with SMTP id u15so67499482oie.3
        for <linux-media@vger.kernel.org>; Mon, 02 Jan 2017 11:19:41 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAH-u=834h2T5s6wY44nqo9bb6DR=z1TDynGeWp0B1wMX6bK13w@mail.gmail.com>
References: <1476466481-24030-1-git-send-email-p.zabel@pengutronix.de>
 <20161019213026.GU9460@valkosipuli.retiisi.org.uk> <CAH-u=807nRYzza0kTfOMv1AiWazk6FGJyz6W5_bYw7v9nOrccA@mail.gmail.com>
 <20161229205113.j6wn7kmhkfrtuayu@pengutronix.de> <7350daac-14ee-74cc-4b01-470a375613a3@denx.de>
 <c38d80aa-5464-1e9d-e11a-f54716fdb565@mentor.com> <CAH-u=83LDyfcErrxaDNN2+w7ZK56v9cJkvBL864ofxiBWrmBSg@mail.gmail.com>
 <3b8ed13c-a23e-dc2b-0e31-1288ea3f562a@xs4all.nl> <CAH-u=834h2T5s6wY44nqo9bb6DR=z1TDynGeWp0B1wMX6bK13w@mail.gmail.com>
From: Fabio Estevam <festevam@gmail.com>
Date: Mon, 2 Jan 2017 17:19:40 -0200
Message-ID: <CAOMZO5BipThqVLvFQ77VBzBP7AAKYqbuW2Hqj2XHcso2XM-cRw@mail.gmail.com>
Subject: Re: [PATCH v2 00/21] Basic i.MX IPUv3 capture support
To: Jean-Michel Hautbois <jean-michel.hautbois@veo-labs.com>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Steve Longerbeam <steve_longerbeam@mentor.com>,
        Marek Vasut <marex@denx.de>,
        Robert Schwebel <r.schwebel@pengutronix.de>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Gary Bisson <gary.bisson@boundarydevices.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jean-Michel,

On Mon, Jan 2, 2017 at 12:59 PM, Jean-Michel Hautbois
<jean-michel.hautbois@veo-labs.com> wrote:

> Steve: which branch is the correct one on your github ?

I have tested imx-media-staging-md-v2 (based on 4.9-rc) and also
imx-media-staging-md-v4 branch, which is based on 4.10-rc1.
