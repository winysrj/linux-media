Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f173.google.com ([209.85.221.173]:48365 "EHLO
	mail-qy0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755697AbZJFIMj (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Oct 2009 04:12:39 -0400
Received: by qyk3 with SMTP id 3so3243568qyk.4
        for <linux-media@vger.kernel.org>; Tue, 06 Oct 2009 01:12:03 -0700 (PDT)
Date: Tue, 6 Oct 2009 11:11:59 +0300
From: "Aleksandr V. Piskunov" <aleksandr.v.piskunov@gmail.com>
To: linux-media@vger.kernel.org
Subject: Re: [PATCH] AVerTV MCE 116 Plus radio
Message-ID: <20091006081159.GB22207@moon>
References: <20091006080406.GA22207@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091006080406.GA22207@moon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 06, 2009 at 11:04:06AM +0300, Aleksandr V. Piskunov wrote:
> Added FM radio support to Avermedia AVerTV MCE 116 Plus card
> 

What leaves me puzzled, radio only works ok with ivtv newi2c=1

With default newi2c audio is tinny, metallic, with some strange static.
Similar problem with pvr-150 was reported years ago, guess issue is still
unresolved, perhaps something with cx25840..
