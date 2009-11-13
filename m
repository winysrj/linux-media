Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.26]:14592 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755613AbZKMOnc (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 09:43:32 -0500
Received: by qw-out-2122.google.com with SMTP id 3so663785qwe.37
        for <linux-media@vger.kernel.org>; Fri, 13 Nov 2009 06:43:35 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 13 Nov 2009 15:43:35 +0100
Message-ID: <156a113e0911130643y6c548599q548c1aec92bf7b1f@mail.gmail.com>
Subject: I found I bug in tvtime, where do I report it?
From: Magnus Alm <magnus.alm@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi!

If this is the right place, I can as well try to describe it now.
(And I hope I makes sense.)

The bug is about the "Enable/Disable signal detection".

As it is now in  videoinput.c:

int videoinput_check_for_signal( videoinput_t *vidin, int check_freq_present )
{
    if(  videoinput_freq_present( vidin ) || !check_freq_present ) {
        switch( vidin->cur_tuner_state ) {
        case TUNER_STATE_NO_SIGNAL:


Should be:

int videoinput_check_for_signal( videoinput_t *vidin, int check_freq_present )
{
    if( !check_freq_present || videoinput_freq_present( vidin )) {
        switch( vidin->cur_tuner_state ) {
        case TUNER_STATE_NO_SIGNAL:

So just switch place for "videoinput_freq_present( vidin )" and
"!check_freq_present" so it actually cares if you disable signal
detection.

With this change, disabling signal detection will remove the frame
drops I have in tvtime.


Cheers, have a nice weekend.
Magnus Alm
