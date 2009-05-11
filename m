Return-path: <linux-media-owner@vger.kernel.org>
Received: from web110814.mail.gq1.yahoo.com ([67.195.13.237]:30177 "HELO
	web110814.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752619AbZEKOo1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 11 May 2009 10:44:27 -0400
Message-ID: <46929.35836.qm@web110814.mail.gq1.yahoo.com>
Date: Mon, 11 May 2009 07:44:26 -0700 (PDT)
From: Uri Shkolnik <urishk@yahoo.com>
Subject: Re: [PATCH] [0904_7_2] Siano: smsdvb - purge whitespaces
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: LinuxML <linux-media@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>




--- On Mon, 5/11/09, Mauro Carvalho Chehab <mchehab@infradead.org> wrote:

> From: Mauro Carvalho Chehab <mchehab@infradead.org>
> Subject: Re: [PATCH] [0904_7_2] Siano: smsdvb - purge whitespaces
> To: "Uri Shkolnik" <urishk@yahoo.com>
> Cc: "LinuxML" <linux-media@vger.kernel.org>
> Date: Monday, May 11, 2009, 1:29 PM
> Em Mon, 27 Apr 2009 05:11:27 -0700
> (PDT)
> Uri Shkolnik <urishk@yahoo.com>
> escreveu:
> 
> > 
> > # HG changeset patch
> > # User Uri Shkolnik <uris@siano-ms.com>
> > # Date 1240833806 -10800
> > # Node ID cbd828b0fe102fa023280cfeadbcb20b54a39a47
> > # Parent 
> 39bbe3b24abaaa3e049a855cb51be0b917b0c711
> > Siano: smsdvb - whitespace cleanup
> > 
> > From: Uri Shkolnik <uris@siano-ms.com>
> > 
> > Whitespace cleanup, no implementation changes
> 
> This patch didn't apply. Probably, it were applied out of
> order. The other
> Siano patches I had were already applied. Please check if I
> forgot something.
> 
> > 
> > Priority: normal
> > 
> > Signed-off-by: Uri Shkolnik <uris@siano-ms.com>
> > 
> > diff -r 39bbe3b24aba -r cbd828b0fe10
> linux/drivers/media/dvb/siano/smsdvb.c
> > ---
> a/linux/drivers/media/dvb/siano/smsdvb.c   
> Mon Apr 27 14:43:28 2009 +0300
> > +++
> b/linux/drivers/media/dvb/siano/smsdvb.c   
> Mon Apr 27 15:03:26 2009 +0300
> > @@ -33,15 +33,15 @@ struct smsdvb_client_t {
> >      struct smscore_device_t
> *coredev;
> >      struct smscore_client_t
> *smsclient;
> >  
> > -    struct dvb_adapter   
>   adapter;
> > -    struct dvb_demux   
>     demux;
> > -    struct dmxdev     
>      dmxdev;
> > -    struct dvb_frontend 
>    frontend;
> > +    struct dvb_adapter adapter;
> > +    struct dvb_demux demux;
> > +    struct dmxdev dmxdev;
> > +    struct dvb_frontend frontend;
> >  
> > -    fe_status_t     
>        fe_status;
> > -    int       
>              fe_ber,
> fe_snr, fe_unc, fe_signal_strength;
> > +    fe_status_t fe_status;
> > +    int fe_ber, fe_snr, fe_unc,
> fe_signal_strength;
> >  
> > -    struct completion   
>    tune_done, stat_done;
> > +    struct completion tune_done,
> stat_done;
> >  
> >      /* todo: save freq/band
> instead whole struct */
> >      struct
> dvb_frontend_parameters fe_params;
> > @@ -61,7 +61,7 @@ static int smsdvb_onresponse(void
> *conte
> >      struct smsdvb_client_t
> *client = (struct smsdvb_client_t *) context;
> >      struct SmsMsgHdr_ST *phdr =
> (struct SmsMsgHdr_ST *) (((u8 *) cb->p)
> >         
>     + cb->offset);
> > -    u32 *pMsgData = (u32 *)phdr+1;
> > +    u32 *pMsgData = (u32 *) phdr + 1;
> >      /*u32 MsgDataLen =
> phdr->msgLength - sizeof(struct SmsMsgHdr_ST);*/
> >  
> >     
> /*smsendian_handle_rx_message((struct SmsMsgData_ST *)
> phdr);*/
> > @@ -177,8 +177,8 @@ static int smsdvb_onresponse(void
> *conte
> >  
> >      if (client->fe_status
> & FE_HAS_LOCK)
> >         
> sms_board_led_feedback(client->coredev,
> > -       
>            
>    (client->fe_unc == 0) ?
> > -       
>            
>    SMS_LED_HI : SMS_LED_LO);
> > +       
>         (client->fe_unc ==
> 0) ?
> > +       
>         SMS_LED_HI :
> SMS_LED_LO);
> >      else
> >         
> sms_board_led_feedback(client->coredev, SMS_LED_OFF);
> >  
> > @@ -203,7 +203,7 @@ static void smsdvb_onremove(void
> *contex
> >  {
> >     
> kmutex_lock(&g_smsdvb_clientslock);
> >  
> > -    smsdvb_unregister_client((struct
> smsdvb_client_t *) context);
> > +    smsdvb_unregister_client((struct
> smsdvb_client_t *)context);
> >  
> >     
> kmutex_unlock(&g_smsdvb_clientslock);
> >  }
> > @@ -214,13 +214,12 @@ static int
> smsdvb_start_feed(struct dvb_
> >         
> container_of(feed->demux, struct smsdvb_client_t,
> demux);
> >      struct SmsMsgData_ST PidMsg;
> >  
> > -    sms_debug("add pid %d(%x)",
> > -         
> feed->pid, feed->pid);
> > +    sms_debug("add pid %d(%x)",
> feed->pid, feed->pid);
> >  
> >      PidMsg.xMsgHeader.msgSrcId =
> DVBT_BDA_CONTROL_MSG_ID;
> >      PidMsg.xMsgHeader.msgDstId =
> HIF_TASK;
> >      PidMsg.xMsgHeader.msgFlags =
> 0;
> > -    PidMsg.xMsgHeader.msgType  =
> MSG_SMS_ADD_PID_FILTER_REQ;
> > +    PidMsg.xMsgHeader.msgType =
> MSG_SMS_ADD_PID_FILTER_REQ;
> >      PidMsg.xMsgHeader.msgLength =
> sizeof(PidMsg);
> >      PidMsg.msgData[0] =
> feed->pid;
> >  
> > @@ -234,31 +233,31 @@ static int
> smsdvb_stop_feed(struct dvb_d
> >         
> container_of(feed->demux, struct smsdvb_client_t,
> demux);
> >      struct SmsMsgData_ST PidMsg;
> >  
> > -    sms_debug("remove pid %d(%x)",
> > -         
> feed->pid, feed->pid);
> > +    sms_debug("remove pid %d(%x)",
> feed->pid, feed->pid);
> >  
> >      PidMsg.xMsgHeader.msgSrcId =
> DVBT_BDA_CONTROL_MSG_ID;
> >      PidMsg.xMsgHeader.msgDstId =
> HIF_TASK;
> >      PidMsg.xMsgHeader.msgFlags =
> 0;
> > -    PidMsg.xMsgHeader.msgType  =
> MSG_SMS_REMOVE_PID_FILTER_REQ;
> > +    PidMsg.xMsgHeader.msgType =
> MSG_SMS_REMOVE_PID_FILTER_REQ;
> >      PidMsg.xMsgHeader.msgLength =
> sizeof(PidMsg);
> >      PidMsg.msgData[0] =
> feed->pid;
> >  
> > -    return
> smsclient_sendrequest(client->smsclient,
> > -       
>          
>    &PidMsg, sizeof(PidMsg));
> > +    return
> smsclient_sendrequest(client->smsclient, &PidMsg,
> > +       
>     sizeof(PidMsg));
> >  }
> >  
> >  static int smsdvb_sendrequest_and_wait(struct
> smsdvb_client_t *client,
> > -       
>            
> void *buffer, size_t size,
> > -       
>            
> struct completion *completion)
> > +       
>            
>    void *buffer, size_t size,
> > +       
>            
>    struct completion *completion)
> >  {
> > -    int rc =
> smsclient_sendrequest(client->smsclient, buffer, size);
> > +    int rc;
> > +
> > +    rc =
> smsclient_sendrequest(client->smsclient, buffer, size);
> >      if (rc < 0)
> >          return
> rc;
> >  
> > -    return
> wait_for_completion_timeout(completion,
> > -       
>            
>    msecs_to_jiffies(2000)) ?
> > -       
>            
>     0 : -ETIME;
> > +    return
> wait_for_completion_timeout(completion,
> msecs_to_jiffies(2000))
> > +       
>     ? 0 : -ETIME;
> >  }
> >  
> >  static int smsdvb_read_status(struct
> dvb_frontend *fe, fe_status_t *stat)
> > @@ -333,18 +332,18 @@ static int
> smsdvb_set_frontend(struct dv
> >         
>            struct
> dvb_frontend_parameters *fep)
> >  {
> >      struct smsdvb_client_t
> *client =
> > -       
> container_of(fe, struct smsdvb_client_t, frontend);
> > +    container_of(fe, struct
> smsdvb_client_t, frontend);
> >  
> >      struct {
> > -        struct
> SmsMsgHdr_ST    Msg;
> > -       
> u32        Data[3];
> > +        struct
> SmsMsgHdr_ST Msg;
> > +        u32 Data[3];
> >      } Msg;
> >      int ret;
> >  
> > -    Msg.Msg.msgSrcId  =
> DVBT_BDA_CONTROL_MSG_ID;
> > -    Msg.Msg.msgDstId  =
> HIF_TASK;
> > -    Msg.Msg.msgFlags  = 0;
> > -    Msg.Msg.msgType   =
> MSG_SMS_RF_TUNE_REQ;
> > +    Msg.Msg.msgSrcId =
> DVBT_BDA_CONTROL_MSG_ID;
> > +    Msg.Msg.msgDstId = HIF_TASK;
> > +    Msg.Msg.msgFlags = 0;
> > +    Msg.Msg.msgType =
> MSG_SMS_RF_TUNE_REQ;
> >      Msg.Msg.msgLength =
> sizeof(Msg);
> >      Msg.Data[0] =
> fep->frequency;
> >      Msg.Data[2] = 12000000;
> > @@ -353,14 +352,24 @@ static int
> smsdvb_set_frontend(struct dv
> >           
> fep->frequency, fep->u.ofdm.bandwidth);
> >  
> >      switch
> (fep->u.ofdm.bandwidth) {
> > -    case BANDWIDTH_8_MHZ: Msg.Data[1]
> = BW_8_MHZ; break;
> > -    case BANDWIDTH_7_MHZ: Msg.Data[1]
> = BW_7_MHZ; break;
> > -    case BANDWIDTH_6_MHZ: Msg.Data[1]
> = BW_6_MHZ; break;
> > +    case BANDWIDTH_8_MHZ:
> > +        Msg.Data[1] =
> BW_8_MHZ;
> > +        break;
> > +    case BANDWIDTH_7_MHZ:
> > +        Msg.Data[1] =
> BW_7_MHZ;
> > +        break;
> > +    case BANDWIDTH_6_MHZ:
> > +        Msg.Data[1] =
> BW_6_MHZ;
> > +        break;
> >  #if 0
> > -    case BANDWIDTH_5_MHZ: Msg.Data[1]
> = BW_5_MHZ; break;
> > +    case BANDWIDTH_5_MHZ:
> > +        Msg.Data[1] =
> BW_5_MHZ;
> > +        break;
> >  #endif
> > -    case BANDWIDTH_AUTO: return
> -EOPNOTSUPP;
> > -    default: return -EINVAL;
> > +    case BANDWIDTH_AUTO:
> > +        return
> -EOPNOTSUPP;
> > +    default:
> > +        return
> -EINVAL;
> >      }
> >  
> >      /* Disable LNA, if any. An
> error is returned if no LNA is present */
> > @@ -395,7 +404,7 @@ static int
> smsdvb_get_frontend(struct dv
> >  
> >      /* todo: */
> >      memcpy(fep,
> &client->fe_params,
> > -       
>    sizeof(struct dvb_frontend_parameters));
> > +       
>     sizeof(struct dvb_frontend_parameters));
> >  
> >      return 0;
> >  }
> > 
> > 
> > 
> >       
> > --
> > To unsubscribe from this list: send the line
> "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> 
> Cheers,
> Mauro
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

The exist patches' order is 1..19, patch #1 has been replaced by patches 1.1 (1_1) and 1.2 (1_2), and patches 7 by patches 7.1 ... 7.3 (7_1, 7_2, 7_3).

When you finish to merge the patches which have been approved, please let me know where that merged tree is, and I'll copy it, and continue the patches from that point (kind of synchronization).

Thanks,

Uri


      
