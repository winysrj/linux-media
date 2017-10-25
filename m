Return-path: <linux-media-owner@vger.kernel.org>
Received: from cnc.isely.net ([75.149.91.89]:33059 "EHLO cnc.isely.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751792AbdJYQXp (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Wed, 25 Oct 2017 12:23:45 -0400
Date: Wed, 25 Oct 2017 11:23:44 -0500 (CDT)
From: Mike Isely <isely@isely.net>
Reply-To: Mike Isely at pobox <isely@pobox.com>
To: Kees Cook <keescook@chromium.org>
cc: Mauro Carvalho Chehab <mchehab@kernel.org>,
        linux-media@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Mike Isely at pobox <isely@pobox.com>
Subject: Re: [PATCH] media: pvrusb2: Convert timers to use timer_setup()
In-Reply-To: <CAGXu5jKkzLfk+zynzSiGHcL8W7ZfX8DGGuv0RQrAPw-O_tGF1Q@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1710251122270.7174@cnc.isely.net>
References: <20171024152251.GA104927@beast> <CAGXu5jKkzLfk+zynzSiGHcL8W7ZfX8DGGuv0RQrAPw-O_tGF1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Ack'ed (separate formal reply)

  -Mike

On Wed, 25 Oct 2017, Kees Cook wrote:

> Eek, sorry, this uses timer_setup_on_stack() which is only in -next.
> If you can Ack this, I can carry it in the timer tree.
> 
> Thanks!
> 
> -Kees
> 
> On Tue, Oct 24, 2017 at 5:22 PM, Kees Cook <keescook@chromium.org> wrote:
> > In preparation for unconditionally passing the struct timer_list pointer to
> > all timer callbacks, switch to using the new timer_setup() and from_timer()
> > to pass the timer pointer explicitly.
> >
> > Cc: Mike Isely <isely@pobox.com>
> > Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> > Cc: linux-media@vger.kernel.org
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> >  drivers/media/usb/pvrusb2/pvrusb2-hdw.c | 64 ++++++++++++++++++---------------
> >  1 file changed, 36 insertions(+), 28 deletions(-)
> >
> > diff --git a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
> > index ad5b25b89699..8289ee482f49 100644
> > --- a/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
> > +++ b/drivers/media/usb/pvrusb2/pvrusb2-hdw.c
> > @@ -330,10 +330,10 @@ static void pvr2_hdw_state_log_state(struct pvr2_hdw *);
> >  static int pvr2_hdw_cmd_usbstream(struct pvr2_hdw *hdw,int runFl);
> >  static int pvr2_hdw_commit_setup(struct pvr2_hdw *hdw);
> >  static int pvr2_hdw_get_eeprom_addr(struct pvr2_hdw *hdw);
> > -static void pvr2_hdw_quiescent_timeout(unsigned long);
> > -static void pvr2_hdw_decoder_stabilization_timeout(unsigned long);
> > -static void pvr2_hdw_encoder_wait_timeout(unsigned long);
> > -static void pvr2_hdw_encoder_run_timeout(unsigned long);
> > +static void pvr2_hdw_quiescent_timeout(struct timer_list *);
> > +static void pvr2_hdw_decoder_stabilization_timeout(struct timer_list *);
> > +static void pvr2_hdw_encoder_wait_timeout(struct timer_list *);
> > +static void pvr2_hdw_encoder_run_timeout(struct timer_list *);
> >  static int pvr2_issue_simple_cmd(struct pvr2_hdw *,u32);
> >  static int pvr2_send_request_ex(struct pvr2_hdw *hdw,
> >                                 unsigned int timeout,int probe_fl,
> > @@ -2373,18 +2373,15 @@ struct pvr2_hdw *pvr2_hdw_create(struct usb_interface *intf,
> >         }
> >         if (!hdw) goto fail;
> >
> > -       setup_timer(&hdw->quiescent_timer, pvr2_hdw_quiescent_timeout,
> > -                   (unsigned long)hdw);
> > +       timer_setup(&hdw->quiescent_timer, pvr2_hdw_quiescent_timeout, 0);
> >
> > -       setup_timer(&hdw->decoder_stabilization_timer,
> > -                   pvr2_hdw_decoder_stabilization_timeout,
> > -                   (unsigned long)hdw);
> > +       timer_setup(&hdw->decoder_stabilization_timer,
> > +                   pvr2_hdw_decoder_stabilization_timeout, 0);
> >
> > -       setup_timer(&hdw->encoder_wait_timer, pvr2_hdw_encoder_wait_timeout,
> > -                   (unsigned long)hdw);
> > +       timer_setup(&hdw->encoder_wait_timer, pvr2_hdw_encoder_wait_timeout,
> > +                   0);
> >
> > -       setup_timer(&hdw->encoder_run_timer, pvr2_hdw_encoder_run_timeout,
> > -                   (unsigned long)hdw);
> > +       timer_setup(&hdw->encoder_run_timer, pvr2_hdw_encoder_run_timeout, 0);
> >
> >         hdw->master_state = PVR2_STATE_DEAD;
> >
> > @@ -3539,10 +3536,16 @@ static void pvr2_ctl_read_complete(struct urb *urb)
> >         complete(&hdw->ctl_done);
> >  }
> >
> > +struct hdw_timer {
> > +       struct timer_list timer;
> > +       struct pvr2_hdw *hdw;
> > +};
> >
> > -static void pvr2_ctl_timeout(unsigned long data)
> > +static void pvr2_ctl_timeout(struct timer_list *t)
> >  {
> > -       struct pvr2_hdw *hdw = (struct pvr2_hdw *)data;
> > +       struct hdw_timer *timer = from_timer(timer, t, timer);
> > +       struct pvr2_hdw *hdw = timer->hdw;
> > +
> >         if (hdw->ctl_write_pend_flag || hdw->ctl_read_pend_flag) {
> >                 hdw->ctl_timeout_flag = !0;
> >                 if (hdw->ctl_write_pend_flag)
> > @@ -3564,7 +3567,10 @@ static int pvr2_send_request_ex(struct pvr2_hdw *hdw,
> >  {
> >         unsigned int idx;
> >         int status = 0;
> > -       struct timer_list timer;
> > +       struct hdw_timer timer = {
> > +               .hdw = hdw,
> > +       };
> > +
> >         if (!hdw->ctl_lock_held) {
> >                 pvr2_trace(PVR2_TRACE_ERROR_LEGS,
> >                            "Attempted to execute control transfer without lock!!");
> > @@ -3621,8 +3627,8 @@ static int pvr2_send_request_ex(struct pvr2_hdw *hdw,
> >         hdw->ctl_timeout_flag = 0;
> >         hdw->ctl_write_pend_flag = 0;
> >         hdw->ctl_read_pend_flag = 0;
> > -       setup_timer(&timer, pvr2_ctl_timeout, (unsigned long)hdw);
> > -       timer.expires = jiffies + timeout;
> > +       timer_setup_on_stack(&timer.timer, pvr2_ctl_timeout, 0);
> > +       timer.timer.expires = jiffies + timeout;
> >
> >         if (write_len && write_data) {
> >                 hdw->cmd_debug_state = 2;
> > @@ -3677,7 +3683,7 @@ status);
> >         }
> >
> >         /* Start timer */
> > -       add_timer(&timer);
> > +       add_timer(&timer.timer);
> >
> >         /* Now wait for all I/O to complete */
> >         hdw->cmd_debug_state = 4;
> > @@ -3687,7 +3693,7 @@ status);
> >         hdw->cmd_debug_state = 5;
> >
> >         /* Stop timer */
> > -       del_timer_sync(&timer);
> > +       del_timer_sync(&timer.timer);
> >
> >         hdw->cmd_debug_state = 6;
> >         status = 0;
> > @@ -3769,6 +3775,8 @@ status);
> >         if ((status < 0) && (!probe_fl)) {
> >                 pvr2_hdw_render_useless(hdw);
> >         }
> > +       destroy_timer_on_stack(&timer.timer);
> > +
> >         return status;
> >  }
> >
> > @@ -4366,9 +4374,9 @@ static int state_eval_encoder_run(struct pvr2_hdw *hdw)
> >
> >
> >  /* Timeout function for quiescent timer. */
> > -static void pvr2_hdw_quiescent_timeout(unsigned long data)
> > +static void pvr2_hdw_quiescent_timeout(struct timer_list *t)
> >  {
> > -       struct pvr2_hdw *hdw = (struct pvr2_hdw *)data;
> > +       struct pvr2_hdw *hdw = from_timer(hdw, t, quiescent_timer);
> >         hdw->state_decoder_quiescent = !0;
> >         trace_stbit("state_decoder_quiescent",hdw->state_decoder_quiescent);
> >         hdw->state_stale = !0;
> > @@ -4377,9 +4385,9 @@ static void pvr2_hdw_quiescent_timeout(unsigned long data)
> >
> >
> >  /* Timeout function for decoder stabilization timer. */
> > -static void pvr2_hdw_decoder_stabilization_timeout(unsigned long data)
> > +static void pvr2_hdw_decoder_stabilization_timeout(struct timer_list *t)
> >  {
> > -       struct pvr2_hdw *hdw = (struct pvr2_hdw *)data;
> > +       struct pvr2_hdw *hdw = from_timer(hdw, t, decoder_stabilization_timer);
> >         hdw->state_decoder_ready = !0;
> >         trace_stbit("state_decoder_ready", hdw->state_decoder_ready);
> >         hdw->state_stale = !0;
> > @@ -4388,9 +4396,9 @@ static void pvr2_hdw_decoder_stabilization_timeout(unsigned long data)
> >
> >
> >  /* Timeout function for encoder wait timer. */
> > -static void pvr2_hdw_encoder_wait_timeout(unsigned long data)
> > +static void pvr2_hdw_encoder_wait_timeout(struct timer_list *t)
> >  {
> > -       struct pvr2_hdw *hdw = (struct pvr2_hdw *)data;
> > +       struct pvr2_hdw *hdw = from_timer(hdw, t, encoder_wait_timer);
> >         hdw->state_encoder_waitok = !0;
> >         trace_stbit("state_encoder_waitok",hdw->state_encoder_waitok);
> >         hdw->state_stale = !0;
> > @@ -4399,9 +4407,9 @@ static void pvr2_hdw_encoder_wait_timeout(unsigned long data)
> >
> >
> >  /* Timeout function for encoder run timer. */
> > -static void pvr2_hdw_encoder_run_timeout(unsigned long data)
> > +static void pvr2_hdw_encoder_run_timeout(struct timer_list *t)
> >  {
> > -       struct pvr2_hdw *hdw = (struct pvr2_hdw *)data;
> > +       struct pvr2_hdw *hdw = from_timer(hdw, t, encoder_run_timer);
> >         if (!hdw->state_encoder_runok) {
> >                 hdw->state_encoder_runok = !0;
> >                 trace_stbit("state_encoder_runok",hdw->state_encoder_runok);
> > --
> > 2.7.4
> >
> >
> > --
> > Kees Cook
> > Pixel Security
> 
> 
> 
> 

-- 

Mike Isely
isely @ isely (dot) net
PGP: 03 54 43 4D 75 E5 CC 92 71 16 01 E2 B5 F5 C1 E8
