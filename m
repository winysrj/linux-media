Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:46259 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219AbZGTJ47 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Jul 2009 05:56:59 -0400
Received: by ewy26 with SMTP id 26so2146109ewy.37
        for <linux-media@vger.kernel.org>; Mon, 20 Jul 2009 02:56:58 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 20 Jul 2009 11:56:57 +0200
Message-ID: <d9def9db0907200256j65c1735t456d3d7e9a67a941@mail.gmail.com>
Subject: DMX_SET_FILTER
From: Markus Rechberger <mrechberger@gmail.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I recently went through the DVB API and found following structures for
DMX_SET_FILTER

typedef struct dmx_filter
{
        uint8_t  filter[DMX_FILTER_SIZE];
        uint8_t  mask[DMX_FILTER_SIZE];
        uint8_t  mode[DMX_FILTER_SIZE];
} dmx_filter_t;


struct dmx_sct_filter_params
{
        uint16_t          pid;
        dmx_filter_t   filter;
        uint32_t          timeout;
        uint32_t          flags;
#define DMX_CHECK_CRC       1
#define DMX_ONESHOT         2
#define DMX_IMMEDIATE_START 4
#define DMX_KERNEL_CLIENT   0x8000
};

does anyone know the meaning of following fields?
        uint8_t  filter[DMX_FILTER_SIZE]; // this is the table id
        uint8_t  mask[DMX_FILTER_SIZE]; // ??? it sometimes is set to
0xff, but for PAT it is also 0x00
        uint8_t  mode[DMX_FILTER_SIZE]; // ???

I haven't found any reference for this in the DVB API Specs

regards,
Markus
