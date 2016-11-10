Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:34910 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932295AbcKJN06 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 10 Nov 2016 08:26:58 -0500
From: Andi Shyti <andi.shyti@samsung.com>
To: Rob Herring <robh@kernel.org>,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org, Andi Shyti <andi.shyti@samsung.com>
Subject: [RFC] Documentation: media, leds: move IR LED remote controllers from
 media to LED
Date: Thu, 10 Nov 2016 22:26:50 +0900
Message-id: <20161110132650.5109-1-andi.shyti@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

this is purely a request for comments after a discussion had with
Rob and Jacek [*] about where to place the ir leds binding. Rob wants
the binding to be under led, while Jacek wants it in media...
"Ubi maior minor cessat": it goes to LED and they can be organized
in a subdirectory.

Standing to Rob "Bindings are grouped by types of h/w and IR LEDs
are a type of LED": all remote controllers have an IR LED as core
device, even though the framework is under drivers/media/rc/, thus
they naturally belong to the LED binding group.

Please, let me know if this is the right approach.

Thanks,
Andi

[*] https://lkml.org/lkml/2016/9/12/380
    https://lkml.org/lkml/2016/11/9/622
---
 .../devicetree/bindings/{media => leds/ir-leds}/gpio-ir-receiver.txt      | 0
 Documentation/devicetree/bindings/{media => leds/ir-leds}/hix5hd2-ir.txt  | 0
 Documentation/devicetree/bindings/{media => leds/ir-leds}/img-ir-rev1.txt | 0
 Documentation/devicetree/bindings/{media => leds/ir-leds}/meson-ir.txt    | 0
 Documentation/devicetree/bindings/{media => leds/ir-leds}/nokia,n900-ir   | 0
 Documentation/devicetree/bindings/{media => leds/ir-leds}/st-rc.txt       | 0
 Documentation/devicetree/bindings/{media => leds/ir-leds}/sunxi-ir.txt    | 0
 7 files changed, 0 insertions(+), 0 deletions(-)
 rename Documentation/devicetree/bindings/{media => leds/ir-leds}/gpio-ir-receiver.txt (100%)
 rename Documentation/devicetree/bindings/{media => leds/ir-leds}/hix5hd2-ir.txt (100%)
 rename Documentation/devicetree/bindings/{media => leds/ir-leds}/img-ir-rev1.txt (100%)
 rename Documentation/devicetree/bindings/{media => leds/ir-leds}/meson-ir.txt (100%)
 rename Documentation/devicetree/bindings/{media => leds/ir-leds}/nokia,n900-ir (100%)
 rename Documentation/devicetree/bindings/{media => leds/ir-leds}/st-rc.txt (100%)
 rename Documentation/devicetree/bindings/{media => leds/ir-leds}/sunxi-ir.txt (100%)

diff --git a/Documentation/devicetree/bindings/media/gpio-ir-receiver.txt b/Documentation/devicetree/bindings/leds/ir-leds/gpio-ir-receiver.txt
similarity index 100%
rename from Documentation/devicetree/bindings/media/gpio-ir-receiver.txt
rename to Documentation/devicetree/bindings/leds/ir-leds/gpio-ir-receiver.txt
diff --git a/Documentation/devicetree/bindings/media/hix5hd2-ir.txt b/Documentation/devicetree/bindings/leds/ir-leds/hix5hd2-ir.txt
similarity index 100%
rename from Documentation/devicetree/bindings/media/hix5hd2-ir.txt
rename to Documentation/devicetree/bindings/leds/ir-leds/hix5hd2-ir.txt
diff --git a/Documentation/devicetree/bindings/media/img-ir-rev1.txt b/Documentation/devicetree/bindings/leds/ir-leds/img-ir-rev1.txt
similarity index 100%
rename from Documentation/devicetree/bindings/media/img-ir-rev1.txt
rename to Documentation/devicetree/bindings/leds/ir-leds/img-ir-rev1.txt
diff --git a/Documentation/devicetree/bindings/media/meson-ir.txt b/Documentation/devicetree/bindings/leds/ir-leds/meson-ir.txt
similarity index 100%
rename from Documentation/devicetree/bindings/media/meson-ir.txt
rename to Documentation/devicetree/bindings/leds/ir-leds/meson-ir.txt
diff --git a/Documentation/devicetree/bindings/media/nokia,n900-ir b/Documentation/devicetree/bindings/leds/ir-leds/nokia,n900-ir
similarity index 100%
rename from Documentation/devicetree/bindings/media/nokia,n900-ir
rename to Documentation/devicetree/bindings/leds/ir-leds/nokia,n900-ir
diff --git a/Documentation/devicetree/bindings/media/st-rc.txt b/Documentation/devicetree/bindings/leds/ir-leds/st-rc.txt
similarity index 100%
rename from Documentation/devicetree/bindings/media/st-rc.txt
rename to Documentation/devicetree/bindings/leds/ir-leds/st-rc.txt
diff --git a/Documentation/devicetree/bindings/media/sunxi-ir.txt b/Documentation/devicetree/bindings/leds/ir-leds/sunxi-ir.txt
similarity index 100%
rename from Documentation/devicetree/bindings/media/sunxi-ir.txt
rename to Documentation/devicetree/bindings/leds/ir-leds/sunxi-ir.txt
-- 
2.10.2

