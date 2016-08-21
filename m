Return-path: <linux-media-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:39135 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1752602AbcHUWAb (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sun, 21 Aug 2016 18:00:31 -0400
Date: Sun, 21 Aug 2016 18:00:29 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
To: "Matwey V. Kornilov" <matwey@sai.msu.ru>
cc: Bin Liu <b-liu@ti.com>, <hdegoede@redhat.com>,
        <linux-media@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: pwc over musb: 100% frame drop (lost) on high resolution stream
In-Reply-To: <CAJs94EYxbF5HT35pCNa7LT_AQMj=hVz8L826W-uzdLeQwzYXYQ@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1608211759290.425-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sun, 21 Aug 2016, Matwey V. Kornilov wrote:

> In both cases (with or without HCD_BH), usb_hcd_giveback_urb is called
> every 0.01 sec. It is not clear why behavior is so different.

What behavior are you asking about?  The difference between HCD_BH set 
and not set?

Alan Stern

