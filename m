Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:46957 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986AbZKMPDR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 10:03:17 -0500
Received: by yxe17 with SMTP id 17so2970746yxe.33
        for <linux-media@vger.kernel.org>; Fri, 13 Nov 2009 07:03:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <156a113e0911130643y6c548599q548c1aec92bf7b1f@mail.gmail.com>
References: <156a113e0911130643y6c548599q548c1aec92bf7b1f@mail.gmail.com>
Date: Fri, 13 Nov 2009 10:03:21 -0500
Message-ID: <829197380911130703v600c782eo1158d737c0dc13d0@mail.gmail.com>
Subject: Re: I found I bug in tvtime, where do I report it?
From: Devin Heitmueller <dheitmueller@kernellabs.com>
To: Magnus Alm <magnus.alm@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 13, 2009 at 9:43 AM, Magnus Alm <magnus.alm@gmail.com> wrote:
> Hi!
>
> If this is the right place, I can as well try to describe it now.
> (And I hope I makes sense.)
>
> The bug is about the "Enable/Disable signal detection".
>
> As it is now in  videoinput.c:
>
> int videoinput_check_for_signal( videoinput_t *vidin, int check_freq_present )
> {
>    if(  videoinput_freq_present( vidin ) || !check_freq_present ) {
>        switch( vidin->cur_tuner_state ) {
>        case TUNER_STATE_NO_SIGNAL:
>
>
> Should be:
>
> int videoinput_check_for_signal( videoinput_t *vidin, int check_freq_present )
> {
>    if( !check_freq_present || videoinput_freq_present( vidin )) {
>        switch( vidin->cur_tuner_state ) {
>        case TUNER_STATE_NO_SIGNAL:
>
> So just switch place for "videoinput_freq_present( vidin )" and
> "!check_freq_present" so it actually cares if you disable signal
> detection.
>
> With this change, disabling signal detection will remove the frame
> drops I have in tvtime.
>
>
> Cheers, have a nice weekend.
> Magnus Alm

>From a maintainership standpoint, tvtime is effectively dead.  I've
been planning on setting up a new hg tree over at
http://kernellabs.com/hg since I have some patches I want to get in
there too.  I can add yours to the series.

Cheers,

Devin

-- 
Devin J. Heitmueller - Kernel Labs
http://www.kernellabs.com
