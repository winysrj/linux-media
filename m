Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.horus.com ([78.46.148.228]:49133 "EHLO mail.horus.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751456AbeCTPJr (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 20 Mar 2018 11:09:47 -0400
Date: Tue, 20 Mar 2018 16:09:45 +0100
From: Matthias Reichl <hias@horus.com>
To: Sean Young <sean@mess.org>
Cc: linux-media@vger.kernel.org
Subject: Issue with sharp protocol on ite-cir due to high idle timeout
Message-ID: <20180320150945.u7kutvovkum5ltom@camel2.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sean,

yesterday we received an interesting bug report that might
help to motivate using a lower idle timeout on ite-cir:

https://forum.libreelec.tv/thread/11951-sharp-ir-remote-on-intel-nuc-2820-double-presses/

The rather long message time of the sharp protocol (about 86ms)
in combination with the 200ms default idle timeout of ite-cir
leads to the last message being received after the current 250ms
"keyup" timeout. This results in an additional keyup/keydown
event being generated from the last message. Even a short button
press results in 2 keydown events.

I dont't have any ite-cir hardware here but could reproduce it
with gpio-ir-recv set to 200ms idle timeout. Lowering the
timeout to 100 or 125ms fixed the issue both here and on the
reporter's hardware.

so long,

Hias
