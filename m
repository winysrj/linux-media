Return-Path: <SRS0=dbhF=R4=vger.kernel.org=linux-media-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 508B8C43381
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 23:07:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1834A20828
	for <linux-media@archiver.kernel.org>; Mon, 25 Mar 2019 23:07:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="OHDdBkkD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729250AbfCYXHL (ORCPT <rfc822;linux-media@archiver.kernel.org>);
        Mon, 25 Mar 2019 19:07:11 -0400
Received: from mail-wm1-f52.google.com ([209.85.128.52]:40211 "EHLO
        mail-wm1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfCYXHL (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Mon, 25 Mar 2019 19:07:11 -0400
Received: by mail-wm1-f52.google.com with SMTP id z24so7622920wmi.5
        for <linux-media@vger.kernel.org>; Mon, 25 Mar 2019 16:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JRE83xaZU8v6LyWqyDFU0tkcp8ejlfKVtY/LNgz5x+A=;
        b=OHDdBkkDsJYJUUJV52L8N51TKVmN99oPsFrIl2qGHji0KpffO4GlOFkZMfPE6DZmx0
         njY3qdF4sotQLEBTZXss3mbmMBkEzMZpPFH8WppE0pM5GGzU4XlbjS9MVekUz0pD/TsD
         gstIAwKCsgEK7PuHgqEtP57iipRCQDT2GFOLKSbgxJJ+cWtJQLjn85LOzI6D2mQ+ZN6A
         eCaa1Ss4jbwFXO5tS6uiAI6wY28vOFexRl1u3N7S3TOBe+d2A19PLMcXwgW2HYccGfcN
         Yugu1inPheMmhOD6hUqM1G43KZSYI6aXy4q+Qah8DD12aDXVpLcd0m3VjGjfbtlElp0T
         UTiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JRE83xaZU8v6LyWqyDFU0tkcp8ejlfKVtY/LNgz5x+A=;
        b=AmLVbTLZIFEiETkKkpXxg0OEaUuJvmK/Nexo0CS1XE0mkREu+fod5RzXIfWmKc3dQ/
         omX/CCLdsPyNBD9hMv2GIldG4H74QUlLF9ltD4VrlQgcTJajkkF1ge5IpRaCQWGAlTXX
         evZvBMqOtuXqXW8tI5ndKVrj6pWnQFJ2vCNF8t3OJBWAxM3hZNV4+T/Mg+lPQa3zdRp2
         5kzxXgzJUUkabhGdRb47MtGsGPMhdkBU8Si6UA/3L22iU+nWbIQn3HMj+HQtLugZO943
         bWW8/oT2DxJX6F9iTx+0u4AfsxUxRA2aVv/qwXJP44G2ZzbMj8OZT46oOQ+VtzO+d99Q
         0ROQ==
X-Gm-Message-State: APjAAAXx1CaZPwAv8LD4M6aT7vLv/kG/BpW6fxRIEphXrIs5zXwPmOO4
        MUe1AmT5f/DoeYblWorl/YYDq9UO
X-Google-Smtp-Source: APXvYqwNbLukMwztI/PlEaUjJ6WRjsHcqQOL+I4obriYNo3k5R67Bo6a2abna4Fi5N57LZSnP3sBSQ==
X-Received: by 2002:a1c:5f06:: with SMTP id t6mr13952214wmb.7.1553555229582;
        Mon, 25 Mar 2019 16:07:09 -0700 (PDT)
Received: from rechenknecht2k11 (200116b840bba0002fb4a5b256d59598.dip.versatel-1u1.de. [2001:16b8:40bb:a000:2fb4:a5b2:56d5:9598])
        by smtp.googlemail.com with ESMTPSA id 204sm25433850wmc.1.2019.03.25.16.07.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 25 Mar 2019 16:07:09 -0700 (PDT)
Date:   Tue, 26 Mar 2019 00:07:04 +0100
From:   Benjamin Valentin <benpicco@googlemail.com>
To:     Matthias Reichl <hias@horus.com>
Cc:     Sean Young <sean@mess.org>, linux-media@vger.kernel.org
Subject: Re: [PATCH] media: rc: xbox_remote: add protocol and set timeout
Message-ID: <20190326000704.33fbfac3@rechenknecht2k11>
In-Reply-To: <20190324094351.5584-1-hias@horus.com>
References: <20190324094351.5584-1-hias@horus.com>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-media.vger.kernel.org>
X-Mailing-List: linux-media@vger.kernel.org

Nice! With this applied the remote feels a lot more snugly.

In the forum thread you talked about a toggle bit to distiguish new
button presses from held down buttons.
The packet send by the Xbox Remote includes how much time has passed
since the last packet was sent.

u16 last_press_ms = le16_to_cpup((__le16 *)(data + 4));

If the button was held down, this value will always be 64 or 65 ms, if
the button was released in between, it will be higher than that.
(If you leave the remote idle, it will count to 65535 and stop there)

Maybe this is helpful, I'm not sure what's the right knob to turn with
this information.

Anyway, thank you a lot for the fix!

Acked-by: Benjamin Valentin <benpicco@googlemail.com>
