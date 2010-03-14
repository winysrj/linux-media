Return-path: <linux-media-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:10444 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759562Ab0CNSqo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 14 Mar 2010 14:46:44 -0400
Received: by fg-out-1718.google.com with SMTP id l26so1028463fgb.1
        for <linux-media@vger.kernel.org>; Sun, 14 Mar 2010 11:46:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c1fb08351003140849l23e826d3hfddd3e2aa952d3e5@mail.gmail.com>
References: <c1fb08351003140849l23e826d3hfddd3e2aa952d3e5@mail.gmail.com>
Date: Sun, 14 Mar 2010 20:46:43 +0200
Message-ID: <c1fb08351003141146v3b36a02djd6c127e4081437db@mail.gmail.com>
Subject: Fwd: Leadtek WinFast PxPVR2200
From: Anca Emanuel <anca.emanuel@gmail.com>
To: dougsland <dougsland@redhat.com>, mchehab <mchehab@redhat.com>,
	"d.belimov" <d.belimov@gmail.com>,
	linux-media <linux-media@vger.kernel.org>,
	mkrufky <mkrufky@linuxtv.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

added come cc

---------- Forwarded message ----------
From: Anca Emanuel <anca.emanuel@gmail.com>
Date: Sun, Mar 14, 2010 at 5:49 PM
Subject: Leadtek WinFast PxPVR2200
To: linux-kernel <linux-kernel@vger.kernel.org>, Steven Toth <stoth@linuxtv.org>


in the file
drivers\media\video\cx23885\cx23885-cards.c

there is:
CX23885_BOARD_LEADTEK_WINFAST_PXTV1200

it is possible to add LeadTek WinFast PxPVR2200 to that file ?

it uses the CONEXANT PCIe A/V Decoder CX23885-13Z
and CONEXANT MPEG II A/V ENCODER CX23417-11Z
