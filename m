Return-path: <linux-media-owner@vger.kernel.org>
Received: from bhuna.collabora.co.uk ([93.93.135.160]:56871 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755494AbaLHO3k (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 8 Dec 2014 09:29:40 -0500
Message-ID: <5485B5CC.6040101@collabora.com>
Date: Mon, 08 Dec 2014 09:29:32 -0500
From: Nicolas Dufresne <nicolas.dufresne@collabora.com>
MIME-Version: 1.0
To: Bin Chen <bin.chen@linaro.org>, linux-media@vger.kernel.org
Subject: Re: V4l2 state transition
References: <CANC6fRFHYsTrUmAMYBWy9u=7ahCqYqOZLGUqrUDCwQm=FnmUbQ@mail.gmail.com>
In-Reply-To: <CANC6fRFHYsTrUmAMYBWy9u=7ahCqYqOZLGUqrUDCwQm=FnmUbQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Le 2014-12-08 00:19, Bin Chen a écrit :
> Can anyone comment is following state transition diagram for V4l2 user
> space program make sense? Do you see any issues if we were to enforce
> this constraint?
I think you should request some buffers before streamon. If in capture, 
you should also queue the minimum amount of buffers.

Nicolas
