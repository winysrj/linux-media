Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-it0-f44.google.com ([209.85.214.44]:36158 "EHLO
	mail-it0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752304AbcHAKYr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2016 06:24:47 -0400
MIME-Version: 1.0
From: David Binderman <linuxdev.baldrick@gmail.com>
Date: Mon, 1 Aug 2016 11:24:45 +0100
Message-ID: <CAMzoamZL1aLidqpBsySx-iZZQ968GPRYx6uZntXcbACopSZn5A@mail.gmail.com>
Subject: include/linux/cec-funcs.h:1280: suspicious expression ?
To: hans.verkuil@cisco.com, linux-media@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dcb314@hotmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello there,

include/linux/cec-funcs.h:1280:50: warning: logical ‘and’ applied to
non-boolean constant [-Wlogical-op]

Source code is

        msg->msg[4] = ui_cmd->channel_identifier.major && 0xff;

Maybe better code

        msg->msg[4] = ui_cmd->channel_identifier.major & 0xff;

Regards

David Binderman
